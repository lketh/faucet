// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "../../lib/ds-test/src/test.sol";
import "../Faucet.sol";
import "../RustyFounder.sol";

interface Vm {
  function expectEmit(
    bool,
    bool,
    bool,
    bool
  ) external;

  function expectRevert(bytes calldata) external;

  function expectRevert(bytes4) external;

  function startPrank(address, address) external;

  function stopPrank() external;

  function prank(address, address) external;

  function prank(address) external;

  function deal(address, uint256) external;
}

contract RustyFounderTest is DSTest {
  Vm vm = Vm(HEVM_ADDRESS);
  RustyFounder rustyfounder;
  Faucet faucet;

  address account1 = address(1);
  address account2 = address(2);
  address account3 = address(3);
  address account4 = address(4);
  address account5 = address(5);

  function setUp() public {
    faucet = new Faucet();
    rustyfounder = new RustyFounder(address(faucet));
    faucet.setRustyFounder(address(rustyfounder));
    vm.deal(account1, 2 ether);
  }

  function getTokensByDonation() public {
    assert(true);
  }
}
