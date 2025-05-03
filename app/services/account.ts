import {Account} from 'starknet';

import {provider} from './provider';

if (!process.env.STARKNET_ACCOUNT_ADDRESS) throw new Error('STARKNET_ACCOUNT_ADDRESS is not set');
if (!process.env.STARKNET_ACCOUNT_PRIVATE_KEY) throw new Error('STARKNET_ACCOUNT_PRIVATE_KEY is not set');

export const account = new Account(
  provider,
  process.env.STARKNET_ACCOUNT_ADDRESS,
  process.env.STARKNET_ACCOUNT_PRIVATE_KEY,
);
