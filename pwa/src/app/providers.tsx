'use client';
// import '@rainbow-me/rainbowkit/styles.css';
import { ChakraProvider } from '@chakra-ui/react';
// import { ThemeProvider } from 'next-themes';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { createConfig, http } from 'wagmi';
import { mainnet, sepolia } from 'wagmi/chains';

import StarknetProvider from '@/context/StarknetProvider';

import system from '../theme'; // Import your custom theme
import { SessionProvider } from 'next-auth/react';
// import {Chain} from 'viem';
// import {WagmiProvider} from 'wagmi';
// import {getDefaultConfig, RainbowKitProvider} from '@rainbow-me/rainbowkit';


export const CHAINS_CONFIG = [mainnet, sepolia];
export const TRANSPORTS = {
  [mainnet.id]: http(),
  [sepolia.id]: http(),
};
export const config = createConfig({
  chains: [mainnet, sepolia],
  transports: TRANSPORTS,
  multiInjectedProviderDiscovery: false,
});

// const configRainbow = getDefaultConfig({
//   appName: 'My RainbowKit App',
//   projectId: 'YOUR_PROJECT_ID',
//   chains: [mainnet, sepolia],
//   transports: {
//     [mainnet.id]: http('https://eth-mainnet.g.alchemy.com/v2/...'),
//     [sepolia.id]: http('https://eth-sepolia.g.alchemy.com/v2/...'),
//   },
// });

const queryClient = new QueryClient();

export default function Providers({ children }: { children: React.ReactNode }) {
  return (
    <>
      <ChakraProvider
        value={system}
      // theme={theme}
      >
        <SessionProvider>

          {/* <ThemeProvider value={system}> */}
          {/* <ColorModeProvider
          // options={{
          //   initialColorMode: theme._config.initialColorMode,
          //   useSystemColorMode: theme._config.useSystemColorMode,
          // }}
          > */}
          <StarknetProvider>
            {/* <WagmiProvider config={config} reconnectOnMount={false}> */}
            <QueryClientProvider client={queryClient}>
              {/* <RainbowKitProvider> */}
              {children}
              {/* </RainbowKitProvider> */}
            </QueryClientProvider>
            {/* </WagmiProvider> */}
          </StarknetProvider>
          {/* </ColorModeProvider> */}
          {/* </ThemeProvider> */}
        </SessionProvider>
      </ChakraProvider>
    </>
  );
}
