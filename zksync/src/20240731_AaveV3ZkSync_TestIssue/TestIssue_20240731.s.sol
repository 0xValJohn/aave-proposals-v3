// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {GovV3Helpers, IPayloadsControllerCore} from 'aave-helpers/src/GovV3Helpers.sol';
import {ZkSyncScript} from 'aave-helpers/src/ScriptUtils.sol';
import {AaveV3ZkSync_TestIssue_20240731} from './AaveV3ZkSync_TestIssue_20240731.sol';

// @dev wrapper factory contract for deploying the payload
contract Deploy_AaveV3ZkSync_TestIssue_20240731 {
  address public immutable PAYLOAD;

  constructor() {
    PAYLOAD = GovV3Helpers.deployDeterministicZkSync(
      type(AaveV3ZkSync_TestIssue_20240731).creationCode
    );
  }
}

/**
 * @dev Deploy ZkSync
 * deploy-command: make deploy-ledger contract=zksync/src/20240731_AaveV3ZkSync_TestIssue/TestIssue_20240731.s.sol:DeployZkSync chain=zksync
 * verify-command: FOUNDRY_PROFILE=zksync npx catapulta-verify -b broadcast/TestIssue_20240731.s.sol/324/run-latest.json
 */
contract DeployZkSync is ZkSyncScript {
  function run() external broadcast {
    // deploy payloads
    address payload0 = new Deploy_AaveV3ZkSync_TestIssue_20240731().PAYLOAD();

    // compose action
    IPayloadsControllerCore.ExecutionAction[]
      memory actions = new IPayloadsControllerCore.ExecutionAction[](1);
    actions[0] = GovV3Helpers.buildAction(payload0);

    // register action at payloadsController
    GovV3Helpers.createPayload(actions);
  }
}
