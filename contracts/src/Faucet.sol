// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

interface IERC20 {
  function approve(address spender, uint256 amount) external returns (bool);

  function transfer(address to, uint256 amount) external returns (bool);

  function balanceOf(address account) external view returns (uint256);
}

contract Faucet {
  /** Contract storage */
  address public owner;
  address public faucetWorker;
  address public rustyFounder;
  uint256 public amountAllowed = 1 * (10**17);

  mapping(address => uint256) public lockTime;
  mapping(address => uint256) public rewardLockTime;

  /** Constructor storage */
  constructor() payable {
    owner = msg.sender;
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

  function setAmountAllowed(uint256 _amountAllowed) public onlyOwner {
    amountAllowed = _amountAllowed;
  }

  function setFaucetWorker(address _faucetWorker) public onlyOwner {
    faucetWorker = _faucetWorker;
  }

  function setRustyFounder(address _rustyFounder) public onlyOwner {
    rustyFounder = _rustyFounder;
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

  function withdraw(address _dest) public payable {
    require(block.timestamp > lockTime[_dest], "Lock time has not expired.");
    require(address(this).balance > 2 * amountAllowed, "Not enough funds.");

    lockTime[_dest] = block.timestamp + 1 days;

    if (msg.sender == faucetWorker) {
      refundGas();
    }

    (bool success, ) = _dest.call{ value: (amountAllowed) }("");
    require(success, "Transfer failed.");
  }
}
