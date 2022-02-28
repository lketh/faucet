// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "../lib/solmate/src/tokens/ERC20.sol";

contract RustyFounder is ERC20("RustyFounder", "RF", 18),  {
  constructor(address _faucet) public {
    uint256 totalSupply = 21000*(10**18);
    _mint(_faucet, _totalSupply);
  }
}
