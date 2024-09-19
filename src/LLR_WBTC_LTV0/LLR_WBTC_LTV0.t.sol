// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3Ethereum} from 'aave-address-book/AaveV3Ethereum.sol';
import 'forge-std/Test.sol';
import 'forge-std/console.sol';
import {ProtocolV3TestBase, ReserveConfig} from 'aave-helpers/src/ProtocolV3TestBase.sol';
import {LLR_WBTC_LTV0} from './LLR_WBTC_LTV0.sol';
import {IERC20} from '@openzeppelin/contracts/token/ERC20/IERC20.sol';

interface IPool {
    function getUserAccountData(address user) external view returns (
        uint256 totalCollateralBase,
        uint256 totalDebtBase,
        uint256 availableBorrowsBase,
        uint256 currentLiquidationThreshold,
        uint256 ltv,
        uint256 healthFactor
    );

    function supply(
        address asset,
        uint256 amount,
        address onBehalfOf,
        uint16 referralCode
    ) external;
}

contract LLR_WBTC_LTV0_Test is ProtocolV3TestBase {
  LLR_WBTC_LTV0 internal proposal;
  address constant BORROWER = 0x298a0f3a0241Db28b7f4784C4f344fe55588c838;
  IPool constant POOL = IPool(0x87870Bca3F3fD6335C3F4ce8392D69350B4fA4E2);
  IERC20 constant WBTC = IERC20(0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599);

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('mainnet'), 20784153);
    proposal = new LLR_WBTC_LTV0();
  }

  function test_borrowerCanTopUpAftwerLTV0() public {
    console.log("Starting test_borrowerCanTopUp");
    
    defaultTest(
      'LLR_WBTC_LTV0',
      AaveV3Ethereum.POOL,
      address(proposal)
    );
    
    (, , , , , uint256 healthFactorBefore) = POOL.getUserAccountData(BORROWER);
    console.log("Health Factor t=0:", healthFactorBefore);

    // User adds WBTC collateral
    uint256 amountToSupply = 10e8; // 10 WBTC (WBTC has 8 decimals)
    deal(address(WBTC), BORROWER, amountToSupply);

    vm.startPrank(BORROWER);
    WBTC.approve(address(POOL), amountToSupply);
    POOL.supply(address(WBTC), amountToSupply, BORROWER, 0);
    vm.stopPrank();

    (, , , , , uint256 healthFactorAfter) = POOL.getUserAccountData(BORROWER);
    console.log("Health Factor after WBTC top up:", healthFactorAfter);

    // Assert that the health factor after is greater than the health factor before
    assertGt(healthFactorAfter, healthFactorBefore, "Health factor should improve after top-up");
  }
}