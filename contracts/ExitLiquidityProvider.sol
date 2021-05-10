pragma solidity ^0.6.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IExitLiquidityProvider {
    function requestLiquidity(
        address dest,
        IERC20 erc20,
        uint256 amount,
        uint256 exitNum,
        bytes calldata liquidityProof
    ) external;
}

contract DummyExitLiquidityProvider is IExitLiquidityProvider {
    function requestLiquidity(
        address dest,
        IERC20 erc20,
        uint256 amount,
        uint256 exitNum,
        bytes calldata liquidityProof
    ) external {
        erc20.transfer(dest, amount);
    }
}