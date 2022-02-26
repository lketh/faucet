// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

contract Faucet {
  address public owner;
  uint256 public amountAllowed = 1000000000000000000;

  mapping(address => uint256) public lockTime;

  constructor() payable {
    owner = msg.sender;
  }

  modifier onlyOwner {
    require(msg.sender == owner, "Only owner can call this function.");
    _;
  }

  function setOwner(address newOwner) public onlyOwner {
    owner = newOwner;
  }

  function setAmountallowed(uint256 newAmountAllowed) public onlyOwner {
    amountAllowed = newAmountAllowed;
  }

  function donate() public payable {
  }

  function requestTokens(address payable _requestor) public payable {
    require(block.timestamp > lockTime[msg.sender], "lock time has not expired. Please try again later");
    require(address(this).balance > amountAllowed, "Not enough funds in the faucet. Please donate");

    _requestor.transfer(amountAllowed);


    lockTime[msg.sender] = block.timestamp + 1 days;
  }
}
