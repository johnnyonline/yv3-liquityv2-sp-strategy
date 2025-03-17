pragma solidity ^0.8.18;

import "forge-std/console2.sol";
import {Setup} from "./utils/Setup.sol";

import {StrategyAprOracle} from "../periphery/StrategyAprOracle.sol";

contract OracleTest is Setup {

    StrategyAprOracle public oracle;

    function setUp() public override {
        super.setUp();
        oracle = new StrategyAprOracle(management, multiTroveGetter, collateralRegistry);
    }

    function checkOracle(address _strategy, uint256 _delta) public {
        // Check set up
        assertEq(address(oracle.MULTI_TROVE_GETTER()), multiTroveGetter);
        assertEq(address(oracle.COLLATERAL_REGISTRY()), collateralRegistry);

        uint256 currentApr = oracle.aprAfterDebtChange(_strategy, 0);
        console2.log("currentApr", currentApr);

        // Should be greater than 0 but likely less than 100%
        assertGt(currentApr, 0, "ZERO");
        // assertLt(currentApr, 1e18, "+100%");
        assertLt(currentApr, 1_000_000 * 1e18, "+1M%"); // BOLD's first vulnerable deployment has almost no SP deposits

        uint256 negativeDebtChangeApr = oracle.aprAfterDebtChange(_strategy, -int256(_delta));

        // The apr should go up if deposits go down
        assertLt(currentApr, negativeDebtChangeApr, "negative change");

        uint256 positiveDebtChangeApr = oracle.aprAfterDebtChange(_strategy, int256(_delta));
        assertGt(currentApr, positiveDebtChangeApr, "positive change");
    }

    function test_oracle(uint256 _amount, uint16 _percentChange) public {
        vm.assume(_amount > minFuzzAmount && _amount < maxFuzzAmount);
        _percentChange = uint16(bound(uint256(_percentChange), 10, MAX_BPS));

        mintAndDepositIntoStrategy(strategy, user, _amount);

        uint256 _delta = (_amount * _percentChange) / MAX_BPS;

        checkOracle(address(strategy), _delta);
    }

    // TODO: Deploy multiple strategies with different tokens as `asset` to test against the oracle.

}
