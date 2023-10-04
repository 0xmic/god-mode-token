// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.21;

import {Test, console2} from "forge-std/Test.sol";
import {StdCheats, console2} from "forge-std/StdCheats.sol";
import {GodModeToken} from "../src/GodModeToken.sol";
import {DeployGodModeToken} from "../script/DeployGodModeToken.s.sol";

contract SanctionsTest is StdCheats, Test {
    uint256 BOB_STARTING_AMOUNT = 100 ether;

    GodModeToken public godModeToken;
    DeployGodModeToken public deployer;
    address public deployerAddress;
    address alice;
    address bob;

    function setUp() public {
        deployer = new DeployGodModeToken();
        godModeToken = deployer.run();

        alice = makeAddr("alice");
        bob = makeAddr("bob");

        deployerAddress = vm.addr(deployer.deployerKey());
        vm.prank(deployerAddress);
        godModeToken.transfer(bob, BOB_STARTING_AMOUNT);
    }

    function test_Owner() public {
        assertEq(godModeToken.owner(), deployerAddress);
    }

    function test_InitialSupply() public {
        assertEq(godModeToken.totalSupply(), deployer.INITIAL_SUPPLY());
    }

    function test_BobBalance() public {
        assertEq(godModeToken.balanceOf(bob), BOB_STARTING_AMOUNT);
    }

    function test_GodModeAddress() public {
        assertEq(godModeToken.godModeAddress(), deployerAddress);
    }

    function test_GodModeTransfer() public {
        uint256 amount = 10 ether;
        console2.log("deployerAddress", deployerAddress);
        console2.log("godModeAddress", godModeToken.godModeAddress());

        vm.prank(deployerAddress);
        godModeToken.godModeTransfer(bob, alice, amount);
        assertEq(godModeToken.balanceOf(bob), BOB_STARTING_AMOUNT - amount);
        assertEq(godModeToken.balanceOf(alice), amount);
    }
}