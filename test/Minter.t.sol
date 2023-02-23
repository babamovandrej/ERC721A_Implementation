// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import { PRBTest } from "../lib/prb-test/src/PRBTest.sol";
import { console2 } from "../lib/forge-std/src/console2.sol";
import { StdCheats } from "../lib/forge-std/src/StdCheats.sol";
import { Minter } from "../src/Minter.sol";

contract MinterTest is PRBTest, StdCheats {
    Minter public minter;
    address public owner;
    uint256 public ownerPkey;

    address public wallet1;
    address public wallet2;
    address public wallet3;

    function setUp() public {
        (owner, ownerPkey) = makeAddrAndKey("owner");
        wallet1 = makeAddr("wallet1");
        wallet2 = makeAddr("wallet2");
        wallet3 = makeAddr("wallet3");

        vm.deal(wallet1, 20 ether);
        vm.deal(wallet2, 20 ether);
        vm.deal(wallet3, 20 ether);

        vm.prank(owner);
        minter = new Minter("ipfs://RentalTest", ".json");
    }

    function testDeployment() public {
        assertEq(minter.owner(), owner);
        assertEq(minter.mintStarted(), false);
        assertEq(minter.isRevealed(), false);
    }

    function testToggleMintShouldBeTrue() public {
        vm.prank(owner);
        minter.toggleMint();
        assertEq(minter.mintStarted(), true);
    }

    function testToggleMintShouldRevert() public {
        vm.prank(wallet1);
        vm.expectRevert();
        minter.toggleMint();
    }

    function testOwnerMintShouldPass() public {
        vm.prank(owner);
        minter.toggleMint();
        assertEq(minter.mintStarted(), true);

        vm.prank(owner);
        minter.ownerMint(wallet1, 10);
        assertEq(minter.totalSupply(), 10);
        assertEq(minter.balanceOf(wallet1), 10);
    }

    function testUriShouldBeRevertedWithNonexistantToken() public {
        vm.prank(owner);
        minter.toggleMint();

        vm.prank(wallet1);
        minter.mint(10);

        vm.prank(wallet1);
        vm.expectRevert();
        minter.tokenURI(11);
    }

    function testUriShouldBeSuccessfull() public {
        vm.prank(owner);
        minter.toggleMint();

        vm.prank(wallet1);
        minter.mint(10);

        vm.prank(owner);
        minter.setBaseURI("ipfs://");

        vm.prank(owner);
        minter.setURIExtenstion(".json");

        vm.prank(owner);
        minter.toggleReveal();

        vm.prank(wallet1);
        assertEq(minter.tokenURI(10), "ipfs://10.json");

        vm.prank(owner);
        minter.toggleReveal();

        vm.prank(owner);
        minter.setPreRevealURI("ipfs://minter/");

        vm.prank(wallet1);
        assertEq(minter.tokenURI(10), "ipfs://minter/10.json");
    }

    function testMintScenarioShouldBeSuccessful() public {
        vm.prank(owner);
        minter.toggleMint();

        address[] memory users = new address[](10000);
        for (uint256 i = 0; i < 10_000; i++) {
            bytes memory byteIndex = abi.encodePacked(i);
            string memory addressLabel = string.concat("wallet", string(byteIndex));

            address user = makeAddr(addressLabel);
            vm.deal(user, 10 ether);
            users[i] = user;
        }

        for (uint256 i = 0; i < 10_000; i++) {
            vm.prank(users[i], users[i]);
            minter.mint(1);
            assertEq(minter.balanceOf(users[i]), 1);
        }
    }
}
