// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.18;

import { Script } from "forge-std/Script.sol";
import { Minter } from "../src/Minter.sol";

/// @dev See the Solidity Scripting tutorial: https://book.getfoundry.sh/tutorials/solidity-scripting
contract DeployFoo is Script {
    address internal deployer;
    Minter internal minter;

    function setUp() public virtual {
        string memory mnemonic = vm.envString("MNEMONIC");
        (deployer,) = deriveRememberKey(mnemonic, 0);
    }

    function run() public {
        vm.startBroadcast(deployer);
        minter = new Minter("ifps://",".json");
        vm.stopBroadcast();
    }
}
