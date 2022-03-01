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

  function warp(uint256) external;

  function expectRevert(bytes calldata) external;

  function expectRevert(bytes4) external;

  function startPrank(address) external;

  function stopPrank() external;

  function prank(address, address) external;

  function prank(address) external;

  function deal(address, uint256) external;
}

contract FaucetTest is DSTest {
  Vm vm = Vm(HEVM_ADDRESS);
  Faucet faucet;
  RustyFounder rustyfounder;
  address founder1 = address(1);
  address founder2 = address(2);
  address worker1 = address(3);
  address worker2 = address(4);
  address account4 = address(5);
  address account5 = address(6);

  function setUp() public {
    faucet = new Faucet();
    rustyfounder = new RustyFounder(address(faucet));
    faucet.setRustyFounder(address(rustyfounder));
    faucet.setFaucetWorker(worker1);

    vm.deal(founder1, 200 ether);
    vm.deal(founder2, 200 ether);
    vm.deal(worker1, 200 ether);
    vm.deal(worker2, 200 ether);
  }

  function testInitialAmountAllowed() public {
    assertTrue(
      faucet.amountAllowed() == 1 * (10**17),
      "the initial allowed amount should be 0.1 ether"
    );
  }

  function testFundTheFaucet() public {
    vm.prank(founder2);
    faucet.donate{ value: 1 ether }();

    assertTrue(
      address(faucet).balance == 1 ether,
      "the faucet should have 1 ether"
    );
  }

  function testRequestFunds() public {
    vm.warp(3 days);
    vm.prank(founder1);
    faucet.donate{ value: 5 ether }();

    vm.warp(1 days);
    vm.prank(worker1);
    faucet.withdraw(account4);

    assertTrue(
      address(faucet).balance == 4.9 ether,
      "the faucet should have 4.9 ether remaining"
    );
    assertTrue(
      account4.balance == 0.1 ether,
      "the requester should have 0.1 ether"
    );
    assertTrue(
      rustyfounder.balanceOf(address(faucet)) == 20999e18,
      "the faucet should have 20999 Rusty Founder tokens remaining"
    );
    assertTrue(
      rustyfounder.balanceOf(founder1) == 1e18,
      "the founder should have 1 Rusty Founder token"
    );
  }

  function testCantRequestFundsTwice() public {
    vm.warp(3 days);
    vm.prank(founder1);
    faucet.donate{ value: 5 ether }();

    vm.warp(1 days);
    vm.prank(worker1);
    faucet.withdraw(account4);

    vm.expectRevert(bytes("Lock time has not expired."));
    vm.prank(worker1);
    faucet.withdraw(account4);

    assertTrue(
      address(faucet).balance == 4.9 ether,
      "the faucet should have 4.9 ether remaining"
    );
    assertTrue(
      account4.balance == 0.1 ether,
      "the requester should have 0.1 ether"
    );
    assertTrue(
      account4.balance == 0.1 ether,
      "the requester should have 0.1 ether"
    );
  }

  function testRefundGas() public {
    vm.warp(3 days);
    vm.prank(founder1);
    faucet.donate{ value: 5 ether }();

    uint256 initialWorkerBalance = worker1.balance;
    vm.warp(1 days);
    vm.prank(worker1);
    faucet.withdraw(account4);

    assertTrue(
      address(faucet).balance == 4.9 ether,
      "the faucet should have 4.9 ether remaining"
    );
    assertTrue(
      account4.balance == 0.1 ether,
      "the requester should have 0.1 ether"
    );
    assertTrue(
      rustyfounder.balanceOf(address(faucet)) == 20999e18,
      "the faucet should have 20999 Rusty Founder tokens remaining"
    );
    assertTrue(
      rustyfounder.balanceOf(founder1) == 1e18,
      "the founder should have 1 Rusty Founder token"
    );
    uint256 finalWorkerBalance = worker1.balance;
    assertTrue(
      initialWorkerBalance == finalWorkerBalance,
      "the worker should have the same amount of ether"
    );
  }

  function testChangeWorkerAddress() public {
    assertTrue(
      faucet.faucetWorker() == worker1,
      "the initial worker should be worker1"
    );

    faucet.setFaucetWorker(worker2);

    assertTrue(
      faucet.faucetWorker() == worker2,
      "the final worker should be worker2"
    );
  }

  function testChangeAmountAllowed() public {
    assertTrue(
      faucet.amountAllowed() == 1e17,
      "the initial amount allowed should be 0.1 ether"
    );

    faucet.setAmountAllowed(2e17);

    assertTrue(
      faucet.amountAllowed() == 2e17,
      "the final amount allowed should be 0.2 ether"
    );
  }

  function testChangeFaucetOwner() public {
    assertTrue(
      faucet.owner() == address(this),
      "the initial owner should be this contract"
    );

    faucet.setOwner(founder1);

    assertTrue(
      faucet.owner() == address(founder1),
      "the final owner should be founder1"
    );
  }
}
