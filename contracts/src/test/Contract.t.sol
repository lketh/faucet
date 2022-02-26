// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "../../lib/ds-test/src/test.sol";
import "../Contract.sol";

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

contract FaucetTest is DSTest {
    Vm vm = Vm(HEVM_ADDRESS);
    Faucet faucet;

    function setUp() public {
        faucet = new Faucet();
    }

    function testInitialAmountAllowed() public {
        assertTrue(faucet.amountAllowed() == 1000000000000000000);
    }

    function testFundTheFaucet() public {
        vm.prank(address(2));
        vm.deal(address(2), 2);

        faucet.donate{value: 2}();

        assertTrue(address(faucet).balance == 2);
    }
}
