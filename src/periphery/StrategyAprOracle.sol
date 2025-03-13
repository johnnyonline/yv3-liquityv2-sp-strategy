// SPDX-License-Identifier: AGPL-3.0
pragma solidity ^0.8.18;

import {AprOracleBase} from "@periphery/AprOracle/AprOracleBase.sol";

// @todo -- ir's + debt amount == revenue to sp (+ liqs)
// average rate * debt / SP deposits
// multiTroveGetter.getMultipleSortedTroves(uint256 _collIndex, int256 _startIdx, uint256 _count)
// uint256 _count == sortedTroves.getSize()
// SP deposits == sp.getTotalBoldDeposits()
contract StrategyAprOracle is AprOracleBase {

    constructor() AprOracleBase("Strategy Apr Oracle Example", msg.sender) {}

    /**
     * @notice Will return the expected Apr of a strategy post a debt change.
     * @dev _delta is a signed integer so that it can also represent a debt
     * decrease.
     *
     * This should return the annual expected return at the current timestamp
     * represented as 1e18.
     *
     *      ie. 10% == 1e17
     *
     * _delta will be == 0 to get the current apr.
     *
     * This will potentially be called during non-view functions so gas
     * efficiency should be taken into account.
     *
     * @param _strategy The token to get the apr for.
     * @param _delta The difference in debt.
     * @return . The expected apr for the strategy represented as 1e18.
     */
    function aprAfterDebtChange(address _strategy, int256 _delta) external view override returns (uint256) {
        // TODO: Implement any necessary logic to return the most accurate
        //      APR estimation for the strategy.
        return 1e17;
    }

}
