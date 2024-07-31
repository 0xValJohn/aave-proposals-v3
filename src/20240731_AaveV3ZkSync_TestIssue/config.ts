import {ConfigFile} from '../../generator/types';
export const config: ConfigFile = {
  rootOptions: {
    pools: ['AaveV3ZkSync'],
    title: 'TestIssue',
    shortName: 'TestIssue',
    date: '20240731',
    author: 'BGD',
    discussion: '',
    snapshot: '',
    votingNetwork: 'POLYGON',
  },
  poolOptions: {AaveV3ZkSync: {configs: {OTHERS: {}}, cache: {blockNumber: 40475624}}},
};
