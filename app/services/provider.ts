import {constants, RpcProvider} from 'starknet';

const NETWORK_NAME = process.env.STARKNET_NETWORK_NAME as string || 'SN_SEPOLIA';
if (!process.env.STARKNET_PROVIDER_URL) throw new Error('STARKNET_PROVIDER_URL is not set');

export const provider = new RpcProvider({
  nodeUrl: process.env.STARKNET_PROVIDER_URL,
  chainId: constants.StarknetChainId[NETWORK_NAME as constants.NetworkName],
});
