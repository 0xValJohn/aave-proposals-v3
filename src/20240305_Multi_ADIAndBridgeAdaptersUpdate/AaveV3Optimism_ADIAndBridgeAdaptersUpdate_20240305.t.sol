// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3Optimism} from 'aave-address-book/AaveV3Optimism.sol';
import {AaveV3Optimism_ADIAndBridgeAdaptersUpdate_20240305} from './AaveV3Optimism_ADIAndBridgeAdaptersUpdate_20240305.sol';
import {MiscOptimism} from 'aave-address-book/MiscOptimism.sol';
import {GovernanceV3Optimism} from 'aave-address-book/GovernanceV3Optimism.sol';
import {GovernanceV3Ethereum} from 'aave-address-book/GovernanceV3Ethereum.sol';
import './BaseTest.sol';

/**
 * @dev Test for AaveV3Optimism_ADIAndBridgeAdaptersUpdate_20240305
 * command: make test-contract filter=AaveV3Optimism_ADIAndBridgeAdaptersUpdate_20240305
 */
contract AaveV3Optimism_ADIAndBridgeAdaptersUpdate_20240305_Test is BaseTest {
  AaveV3Optimism_ADIAndBridgeAdaptersUpdate_20240305 internal payload;

  constructor()
    BaseTest(
      GovernanceV3Optimism.CROSS_CHAIN_CONTROLLER,
      MiscOptimism.PROXY_ADMIN,
      'optimism',
      117321235
    )
  {}

  function setUp() public {
    payload = new AaveV3Optimism_ADIAndBridgeAdaptersUpdate_20240305();
    payloadAddress = address(payload);
  }

  function _getAdapterNames() internal override returns (AdapterName[] memory) {
    AdapterName[] memory adapterNames = new AdapterName[](3);
    adapterNames[0] = AdapterName({
      adapter: payload.NEW_ADAPTER(),
      name: 'Optimism native adapter'
    });

    return adapterNames;
  }

  function _getTrustedRemotes() internal view override returns (TrustedRemote[] memory) {
    TrustedRemote[] memory trustedRemotes = new TrustedRemote[](1);
    trustedRemotes[0] = TrustedRemote({
      adapter: payload.NEW_ADAPTER(),
      expectedRemote: GovernanceV3Ethereum.CROSS_CHAIN_CONTROLLER,
      remoteChainId: ChainIds.MAINNET
    });

    return trustedRemotes;
  }

  function _getReceiverAdaptersByChain(
    bool beforeExecution
  ) internal view override returns (AdaptersByChain[] memory) {
    address[] memory adapters = new address[](1);
    AdaptersByChain[] memory receiverAdaptersByChain = AdaptersByChain[](1);

    if (beforeExecution) {
      adapters[0] = payload.ADAPTER_TO_REMOVE();
    } else {
      adapters[0] = payload.NEW_ADAPTER();
    }
    receiverAdaptersByChain[0].adapters = adapters;
    receiverAdaptersByChain[0].chainId = ChainIds.MAINNET;

    return receiverAdaptersByChain;
  }

  function _getAdapterByChain(
    bool beforeExecution
  ) internal view override returns (AdapterAllowed[] memory) {
    AdapterAllowed[] memory adaptersAllowed = new AdapterAllowed[](2);
    adaptersAllowed[0]({
      adapter: payload.ADAPTER_TO_REMOVE(),
      chainId: ChainIds.MAINNET,
      allowed: true
    });
    adaptersAllowed[1]({adapter: payload.NEW_ADAPTER(), chainId: ChainIds.MAINNET, allowed: false});

    if (!beforeExecution) {
      adaptersAllowed[0].allowed = false;
      adaptersAllowed[1].allowed = true;
    }

    return adaptersAllowed;
  }
}
