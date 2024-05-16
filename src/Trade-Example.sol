// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;
pragma abicoder v2;

import "@uniswap/v3-periphery/contracts/interfaces/external/IWETH9.sol";

import {TransferHelper} from "@uniswap/v3-periphery/contracts/libraries/TransferHelper.sol";
import {ISwapRouter} from "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";

contract trade {
    ISwapRouter public constant PswapRouter =
        ISwapRouter(0x1b81D678ffb9C0263b24A97847620C99d213eB14);
    ISwapRouter public constant swapRouter =
        ISwapRouter(0xE592427A0AEce92De3Edee1F18E0157C05861564);
    IWETH9 public constant KON =
        IWETH9(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
    address public constant USDT = 0xdAC17F958D2ee523a2206206994597C13D831ec7;
    address public constant ETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    uint24 public constant feeTier = 3000;
    uint public amountOut;

    function viewUSDT() public view returns (uint balance) {
        balance = IERC20(0xdAC17F958D2ee523a2206206994597C13D831ec7).balanceOf(
            address(this)
        );
        return (balance);
    }

    function viewBalance() public view returns (uint balance) {
        balance = KON.balanceOf(address(this));

        return (balance);
    }

    function swapETHtoWETH() public payable {
        KON.deposit{value: msg.value}();
        KON.transfer(address(this), msg.value);
    }

    function tradeUniswap() public payable {
        TransferHelper.safeApprove(USDT, address(swapRouter), 0);
        TransferHelper.safeApprove(USDT, address(swapRouter), amountOut);
        uint256 minOut = 0;
        uint160 priceLimit = 0;

        ISwapRouter.ExactInputSingleParams memory swapparams = ISwapRouter
            .ExactInputSingleParams({
                tokenIn: USDT,
                tokenOut: ETH,
                fee: feeTier,
                recipient: address(this),
                deadline: block.timestamp + 30,
                amountIn: amountOut,
                amountOutMinimum: minOut,
                sqrtPriceLimitX96: priceLimit
            });

        amountOut = swapRouter.exactInputSingle(swapparams);
    }

    function tradePancakeswap() public payable {
        TransferHelper.safeApprove(ETH, address(PswapRouter), 1 ether);

        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter
            .ExactInputSingleParams({
                tokenIn: ETH,
                tokenOut: USDT,
                fee: 500,
                recipient: address(this),
                deadline: block.timestamp + 30,
                amountIn: 1 ether,
                amountOutMinimum: 0,
                sqrtPriceLimitX96: 0
            });

        amountOut = PswapRouter.exactInputSingle(params);
    }

    receive() external payable {}
}
