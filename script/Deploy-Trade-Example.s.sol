//SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;

import {trade} from "../src/Trade-Example.sol";
import {Script} from "forge-std/Script.sol";

contract DeployTradeExample is Script {
    function run() external returns (trade) {
        vm.startBroadcast();
        trade t = new trade();
        vm.stopBroadcast();

        return t;
    }
}
