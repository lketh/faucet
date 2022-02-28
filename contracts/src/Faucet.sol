// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

interface IERC20 {
  function approve(address spender, uint256 amount) external returns (bool);

  function transfer(address to, uint256 amount) external returns (bool);

  function balanceOf(address account) external view returns (uint256);
}

// https://docs.aave.com/developers/v/2.0/the-core-protocol/weth-gateway
interface IWETHGateway {
  function depositETH(
    address lendingPool,
    address onBehalfOf,
    uint16 referralCode
  ) external payable;

  function withdrawETH(
    address lendingPool,
    uint256 amount,
    address onBehalfOf
  ) external;

  function repayETH(
    address lendingPool,
    uint256 amount,
    uint256 rateMode,
    address onBehalfOf
  ) external payable;

  function borrowETH(
    address lendingPool,
    uint256 amount,
    uint256 interesRateMode,
    uint16 referralCode
  ) external;
}

interface ILendingPool {
  function getUserAccountData(address _user)
    external
    view
    returns (
      uint256 totalLiquidityETH,
      uint256 totalCollateralETH,
      uint256 totalBorrowsETH,
      uint256 totalFeesETH,
      uint256 availableBorrowsETH,
      uint256 currentLiquidationThreshold,
      uint256 ltv,
      uint256 healthFactor
    );
}

contract Faucet {
  /** Contract storage */
  address public owner;
  address public faucetWorker;
  address public wethGatewayAddress;
  address public lendingPoolAddress;
  address public rustyFounder;
  uint256 public amountAllowed = 1 * (10**17);

  mapping(address => uint256) public lockTime;
  mapping(address => uint256) public rewardLockTime;

  /** Constructor storage */
  constructor(address _faucetWorker, address _rustyFounder) payable {
    owner = msg.sender;
    faucetWorker = _faucetWorker;
    rustyFounder = _rustyFounder;
  }

  /** Modifiers */
  modifier onlyOwner() {
    require(msg.sender == owner, "Only owner");
    _;
  }

  /** Setters */
  function setOwner(address _owner) public onlyOwner {
    owner = _owner;
  }

  function setAmountallowed(uint256 _amountAllowed) public onlyOwner {
    amountAllowed = _amountAllowed;
  }

  /** Utility function */
  function refundGas() internal {
    uint256 gasAtStart = gasleft();
    uint256 gasSpent = gasAtStart - gasleft() + 30000;

    (bool success, ) = msg.sender.call{ value: (gasSpent * tx.gasprice) }("");
    require(success, "Transfer failed.");
  }

  /** Core functionality of the faucet */
  receive() external payable {}

  function donate() public payable {
    address faucet = address(this);
    IERC20 _rustyFounder = IERC20(rustyFounder);

    if (
      block.timestamp > rewardLockTime[msg.sender] &&
      _rustyFounder.balanceOf(faucet) > 0
    ) {
      _rustyFounder.transfer(msg.sender, 1 * (10**18));
      rewardLockTime[msg.sender] = block.timestamp + 3 days;
    }
  }

  function requestTokens(address payable _dest) public payable {
    require(block.timestamp > lockTime[_dest], "Lock time has not expired.");

    lockTime[_dest] = block.timestamp + 1 days;

    if (msg.sender == faucetWorker) {
      withdraw();
      refundGas();
    }

    _dest.transfer(amountAllowed);
  }

  /** Extra functionality of the faucet: re-invest into AAVE */
  function invest() internal {
    require(msg.sender == faucetWorker, "Only the worker can call this fn");
    require(
      address(this).balance > (4 * amountAllowed),
      "Not enough balance invest"
    );

    IWETHGateway wethGateway = IWETHGateway(address(wethGatewayAddress));
    ILendingPool lendingPool = ILendingPool(address(lendingPoolAddress));

    wethGateway.depositETH(lendingPoolAddress, address(this), 0);
    (, , , , uint256 availableBorrowsEth, , , ) = lendingPool
      .getUserAccountData(address(this));
    wethGateway.borrowETH(lendingPoolAddress, (availableBorrowsEth / 2), 2, 0);
    wethGateway.depositETH(lendingPoolAddress, address(this), 0);
  }

  function withdraw() internal {
    IWETHGateway wethGateway = IWETHGateway(address(wethGatewayAddress));
    ILendingPool lendingPool = ILendingPool(address(lendingPoolAddress));

    // repayETH(
    //   address lendingPool,
    //   uint256 amount,
    //   uint256 rateMode,
    //   address onBehalfOf
    // );
    // withdrawETH(
    //   address lendingPool,
    //   uint256 amount,
    //   address onBehalfOf
    // );
  }
}
