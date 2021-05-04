pragma solidity ^0.6.0;

import "./libs/CompoundPoolController.sol";
import "./libs/AavePoolController.sol";

contract FAggregator {
    // The total amount including the part that is not in the lending protocol
    uint public totalAmount;

    // The amount that is in the lending protocol.
    uint public depositedAmount;
  
    /**
    * @dev Enum for liquidity pools supported by Farmtopia.
    */
    enum LiquidityPool { Compound, Aave }
    
    /**
     * @dev Enum for pool allocation action types supported by Rari.
     */
    enum PoolAllocationAction { Deposit, Withdraw, WithdrawAll }

    /**
     * @dev Emitted when a deposit or withdrawal is made.
     * Note that `amount` is not set for `WithdrawAll` actions.
     */
    event PoolAllocation(PoolAllocationAction indexed action, LiquidityPool indexed pool, uint256 amount);

    // The lending protocol that we're currently using/
    LiquidityPool currentLiquidityPool;
  
    function rebalance(LiquidityPool pool) external {
		if (pool != currentLiquidityPool) {
			withdrawFromPool(pool, depositedAmount);
            depositToPool(pool, totalAmount);
            currentLiquidityPool = pool;
            depositedAmount = totalAmount;
		}
	}

	
    /**
    * @dev Deposits funds to the specified pool.
    * @param pool The index of the pool.
    * @param amount The amount of tokens to be deposited.
    */
    function depositToPool(LiquidityPool pool, uint256 amount) internal {
        address erc20Contract = 0x4F96Fe3b7A6Cf9725f59d353F723c1bDb64CA6Aa; // DAI contract
		if (pool == LiquidityPool.Compound) CompoundPoolController.deposit(erc20Contract, amount);
        else if (pool == LiquidityPool.Aave) AavePoolController.deposit(erc20Contract, amount, 0);
        else revert("Invalid pool index.");
        emit PoolAllocation(PoolAllocationAction.Deposit, pool, amount);
  }

    /**
    * @dev Deposits funds to the specified pool.
    * @param pool The index of the pool.
    * @param amount The amount of tokens to be deposited.
    */
    function withdrawFromPool(LiquidityPool pool, uint256 amount) internal {
        address erc20Contract = 0x4F96Fe3b7A6Cf9725f59d353F723c1bDb64CA6Aa; // DAI contract
        if (pool == LiquidityPool.Compound) CompoundPoolController.withdraw(erc20Contract, amount);
        else if (pool == LiquidityPool.Aave) AavePoolController.withdraw(erc20Contract, amount);
        else revert("Invalid pool index.");
        emit PoolAllocation(PoolAllocationAction.Withdraw, pool, amount);
    }

}
