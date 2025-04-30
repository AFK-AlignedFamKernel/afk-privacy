import dotenv from 'dotenv';
import webpack from 'webpack';

dotenv.config();

/** @type {import('next').NextConfig} */
const nextConfig = {

  experimental: {
    // esmExternals: true,
    esmExternals: "loose",
    outputFileTracingIncludes: {
      '/api/messages': [
        './node_modules/@aztec/bb.js/dest/node/barretenberg_wasm/**/*',
        './node_modules/@aztec/bb.js/dest/node/barretenberg_wasm/barretenberg_wasm_thread/factory/node/thread.worker.js'
      ],
      '/api/messages/': [
        './node_modules/@aztec/bb.js/dest/node/barretenberg_wasm/**/*',
        './node_modules/@aztec/bb.js/dest/node/barretenberg_wasm/barretenberg_wasm_thread/factory/node/thread.worker.js'
      ],
      // '/api/register/zk-passport': [
      //   // './node_modules/@zkpassport/sdk/**/*',
      //   './node_modules/@zkpassport/sdk/node_modules/@aztec/bb.js/dest/node/barretenberg_wasm/**/*',
      //   './node_modules/@zkpassport/sdk/node_modules/@aztec/bb.js/dest/node/barretenberg_wasm/barretenberg_wasm_thread/factory/node/thread.worker.js'
      // ],
    },
  },
  reactStrictMode: false,
  sassOptions: {
    includePaths: ['./'],
  },
  images: {
    remotePatterns: [
      {
        protocol: 'https',
        hostname: 'developers.google.com',
      },
      {
        protocol: 'https',
        hostname: 'img.logo.dev',
      },
    ],
  },
  env: {
    NEXT_PUBLIC_GOOGLE_CLIENT_ID: process.env.NEXT_PUBLIC_GOOGLE_CLIENT_ID,


  },
  webpack: (config, { isServer }) => {
    config.experiments = {
      asyncWebAssembly: true,
      syncWebAssembly: true,
      layers: true,
      topLevelAwait: true,
    };

    // if (isServer) {
    //   config.resolve = {
    //     ...config.resolve,
    //     alias: {
    //       ...config.resolve.alias,
    //       // '@zkpassport/sdk': '@zkpassport/sdk' ,
    //       // '@zkpassport/sdk': '@zkpassport/sdk/dist/esm/index.js',
    //       // 'websocket': '@zkpassport/sdk/dist/esm/websocket'  // Alias websocket to ws module
    //     },
    //     fallback: {
    //       ...config.resolve.fallback,
    //       worker_threads: false,
    //       fs: false,
    //       net: false,
    //       tls: false
    //     }
    //   };
    // }

    return config;
  },
  // async headers() {
  //   return [
  //     {
  //       // Exclude all oauth-callback paths
  //       source: '/((?!oauth-callback).*)',
  //       headers: [
  //         {
  //           key: 'Cross-Origin-Embedder-Policy',
  //           value: 'require-corp',
  //         },
  //         {
  //           key: 'Cross-Origin-Opener-Policy',
  //           value: 'same-origin',
  //         },
  //       ],
  //     },
  //     {
  //       // Special case for iOS devices - disable COOP/COEP
  //       source: '/((?!oauth-callback).*)',
  //       headers: [
  //         {
  //           key: 'Cross-Origin-Embedder-Policy',
  //           value: 'unsafe-none',
  //         },
  //         {
  //           key: 'Cross-Origin-Opener-Policy',
  //           value: 'unsafe-none',
  //         },
  //       ],
  //       // Only apply these headers for iOS devices
  //       has: [
  //         {
  //           type: 'header',
  //           key: 'user-agent',
  //           value: '(.*iPhone|iPad|iPod.*)',
  //         },
  //       ],
  //     },
  //   ];
  // },
};

export default nextConfig;