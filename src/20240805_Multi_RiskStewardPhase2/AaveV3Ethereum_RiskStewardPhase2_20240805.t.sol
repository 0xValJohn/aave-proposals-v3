// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3Ethereum} from 'aave-address-book/AaveV3Ethereum.sol';

import 'forge-std/Test.sol';
import {ProtocolV3TestBase, ReserveConfig} from 'aave-helpers/src/ProtocolV3TestBase.sol';
import {AaveV3Ethereum_RiskStewardPhase2_20240805} from './AaveV3Ethereum_RiskStewardPhase2_20240805.sol';

/**
 * @dev Test for AaveV3Ethereum_RiskStewardPhase2_20240805
 * command: FOUNDRY_PROFILE=mainnet forge test --match-path=src/20240805_Multi_RiskStewardPhase2/AaveV3Ethereum_RiskStewardPhase2_20240805.t.sol -vv
 */
contract AaveV3Ethereum_RiskStewardPhase2_20240805_Test is ProtocolV3TestBase {
  AaveV3Ethereum_RiskStewardPhase2_20240805 internal proposal;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('mainnet'), 20460200);
    proposal = new AaveV3Ethereum_RiskStewardPhase2_20240805();
  }

  /**
   * @dev executes the generic test suite including e2e and config snapshots
   */
  function test_defaultProposalExecution() public {
    defaultTest(
      'AaveV3Ethereum_RiskStewardPhase2_20240805',
      AaveV3Ethereum.POOL,
      address(proposal)
    );
  }

  function test_permissions() public {
    assertEq(AaveV3Ethereum.ACL_MANAGER.isRiskAdmin(AaveV3Ethereum.CAPS_PLUS_RISK_STEWARD), true);
    executePayload(vm, address(proposal));

    assertEq(AaveV3Ethereum.ACL_MANAGER.isRiskAdmin(AaveV3Ethereum.CAPS_PLUS_RISK_STEWARD), false);
    assertEq(AaveV3Ethereum.ACL_MANAGER.isRiskAdmin(proposal.NEW_RISK_STEWARD()), true);
  }
}
