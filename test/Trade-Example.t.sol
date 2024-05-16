//SPDX-License-Identifier: MIT

pragma solidity ^0.7.6;
pragma abicoder v2;

import {Test, console} from "forge-std/Test.sol";
import {trade} from "../src/Trade-Example.sol";
import {DeployTradeExample} from "../script/Deploy-Trade-Example.s.sol";

contract TradeExampleTest is Test {
    trade tradeExample;

    address user = makeAddr("user");

    function setUp() external {
        DeployTradeExample deployTradeExample = new DeployTradeExample();
        tradeExample = deployTradeExample.run();
        vm.deal(user, 10 ether);
    }

    function testSwapEthtoWETH() public payable {
        vm.prank(user);
        tradeExample.swapETHtoWETH{value: 10 ether}();
        uint balance = tradeExample.viewBalance();
        console.log(balance);
        assert(balance == 10 ether);
    }

    function testTradePancakeSwap() public payable {
        vm.prank(user);
        tradeExample.swapETHtoWETH{value: 10 ether}();

        tradeExample.tradePancakeswap();
        uint balance = tradeExample.viewUSDT();
        console.log(balance);
        assert(balance != 0);
    }

    function testTradeUniswap() public payable {
        vm.prank(user);
        tradeExample.swapETHtoWETH{value: 10 ether}();

        tradeExample.tradePancakeswap();

        tradeExample.tradeUniswap();

        uint balance = tradeExample.viewBalance();
        console.log(balance);
        assert(balance != 10 ether);
    }
}
