// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3EthereumLido, AaveV3EthereumLidoEModes} from 'aave-address-book/AaveV3EthereumLido.sol';
import {AaveV3PayloadEthereumLido} from 'aave-helpers/src/v3-config-engine/AaveV3PayloadEthereumLido.sol';
import {EngineFlags} from 'aave-v3-periphery/contracts/v3-config-engine/EngineFlags.sol';
import {IAaveV3ConfigEngine} from 'aave-v3-periphery/contracts/v3-config-engine/IAaveV3ConfigEngine.sol';
import {IERC20} from 'solidity-utils/contracts/oz-common/interfaces/IERC20.sol';
import {SafeERC20} from 'solidity-utils/contracts/oz-common/SafeERC20.sol';
/**
 * @title Onboard USDS and SUSDS
 * @author ACI
 * - Snapshot: Direct-to-AIP
 * - Discussion: https://governance.aave.com/t/arfc-onboard-usds-and-susds-to-aave-v3/18987
 */
contract AaveV3EthereumLido_OnboardUSDSAndSUSDS_20240914 is AaveV3PayloadEthereumLido {
  using SafeERC20 for IERC20;

  address public constant USDS = 0xdC035D45d973E3EC169d2276DDab16f1e407384F;
  uint256 public constant USDS_SEED_AMOUNT = 100e18;

  function _postExecute() internal override {
    IERC20(USDS).forceApprove(address(AaveV3EthereumLido.POOL), USDS_SEED_AMOUNT);
    AaveV3EthereumLido.POOL.supply(
      USDS,
      USDS_SEED_AMOUNT,
      address(AaveV3EthereumLido.COLLECTOR),
      0
    );
  }

  function newListings() public pure override returns (IAaveV3ConfigEngine.Listing[] memory) {
    IAaveV3ConfigEngine.Listing[] memory listings = new IAaveV3ConfigEngine.Listing[](1);

    listings[0] = IAaveV3ConfigEngine.Listing({
      asset: USDS,
      assetSymbol: 'USDS',
      priceFeed: 0x4F01b76391A05d32B20FA2d05dD5963eE8db20E6,
      eModeCategory: AaveV3EthereumLidoEModes.NONE,
      enabledToBorrow: EngineFlags.ENABLED,
      stableRateModeEnabled: EngineFlags.DISABLED,
      borrowableInIsolation: EngineFlags.DISABLED,
      withSiloedBorrowing: EngineFlags.DISABLED,
      flashloanable: EngineFlags.ENABLED,
      ltv: 63_00,
      liqThreshold: 72_00,
      liqBonus: 7_50,
      reserveFactor: 25_00,
      supplyCap: 50_000_000,
      borrowCap: 45_000_000,
      debtCeiling: 0,
      liqProtocolFee: 10_00,
      rateStrategyParams: IAaveV3ConfigEngine.InterestRateInputData({
        optimalUsageRatio: 90_00,
        baseVariableBorrowRate: 0,
        variableRateSlope1: 5_50,
        variableRateSlope2: 75_00
      })
    });

    return listings;
  }
}
