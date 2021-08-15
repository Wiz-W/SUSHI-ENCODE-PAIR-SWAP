pragma solidity =0.7.6;


import "./interfaces/ISushiSwapRouter.sol";
import './interfaces/IUniswapV2factory.sol';
import './interfaces/IUniswapV2Pair.sol';
import "./libraries/TransferHelper.sol";
import './interfaces/IERC20.sol';

contract pairSwap {
        
        address public factory;
        
        ISushiSwapRouter public immutable swapRouter;
        
        
        
                    
        constructor( address factory_, ISushiSwapRouter swapRouter_ ) public { 
            factory = factory_;
            swapRouter = swapRouter_; 
        }

        receive() external payable { }

        
        function pairInfo(
                        address tokenA,
                        address tokenB
                        ) external view returns (IUniswapV2Pair pair, uint totalSupply, uint reserveA, uint reserveB) { //, uint reserveA, uint reserveB, uint totalSupply) {
        pair = IUniswapV2Pair(IUniswapV2Factory(factory).getPair(tokenA, tokenB));
        totalSupply = pair.totalSupply();
        (uint reserves0, uint reserves1,) = pair.getReserves();
        (reserveA, reserveB) = tokenA == pair.token0() ? (reserves0, reserves1) : (reserves1, reserves0);
        }


        function pairSwap(address token00, address token01, uint amountInToken00) {
               
                address pair = IUniswapV2Factory(factory).getPair(token00, token01);
                require(pair != address(0), "pair doesn't exist");
                address[] memory path = new address[](2); 
                path[0] = token00; 
                path[1] = token01; 
                TransferHelper.safeApprove(token01, address(swapRouter), amountInToken00);
                IERC20(token01).approve(address(swapRouter), amountInToken00);
             
                uint amountsOut = swapRouter.getAmountsOut(amountTokenBorrowed, path)[1];
                swapRouter.swapExactTokensForTokens(amountInToken00, amountsOut, path, address(this), deadline);
        }
}



