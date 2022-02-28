// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "../../lib/ds-test/src/test.sol";
import "../RustyFounder.sol";

interface Vm {
  function expectEmit(bool,bool,bool,bool) external;
  function expectRevert(bytes calldata) external;
  function expectRevert(bytes4) external;
  function startPrank(address,address) external;
  function stopPrank() external;
  function prank(address,address) external;
  function prank(address) external;
  function deal(address, uint256) external;
}

contract RustyFounderTest is DSTest {
  Vm vm = Vm(HEVM_ADDRESS);
  RustyFounder rustyfounder;

  function setUp() public {
    rustyfounder = new RustyFounder();
  }

  function getTokensByDonation() public {
    assert(true);
  }
}
