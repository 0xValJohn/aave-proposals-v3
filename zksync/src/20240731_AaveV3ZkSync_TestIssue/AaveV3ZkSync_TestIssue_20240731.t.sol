// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3ZkSync} from 'aave-address-book/AaveV3ZkSync.sol';
import {ProtocolV3TestBase, ReserveConfig} from 'aave-helpers/zksync/src/ProtocolV3TestBase.sol';
import {AaveV3ZkSync_TestIssue_20240731} from './AaveV3ZkSync_TestIssue_20240731.sol';

/**
 * @dev Test for AaveV3ZkSync_TestIssue_20240731
 * command: FOUNDRY_PROFILE=zksync forge test --match-path=src/20240731_AaveV3ZkSync_TestIssue/AaveV3ZkSync_TestIssue_20240731.t.sol -vv
 */
contract AaveV3ZkSync_TestIssue_20240731_Test is ProtocolV3TestBase {
  AaveV3ZkSync_TestIssue_20240731 internal proposal;

  function setUp() public override {
    vm.createSelectFork(vm.rpcUrl('zksync'), 40475624);
    proposal = new AaveV3ZkSync_TestIssue_20240731();

    super.setUp();
  }

  /**
   * @dev executes the generic test suite including e2e and config snapshots
   */
  function test_defaultProposalExecution() public {
    defaultTest('AaveV3ZkSync_TestIssue_20240731', AaveV3ZkSync.POOL, address(proposal));
  }
}
