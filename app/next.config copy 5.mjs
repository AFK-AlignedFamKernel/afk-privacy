import dotenv from 'dotenv';
import webpack from 'webpack';

dotenv.config();
/** @type {import('next').NextConfig} */
const nextConfig = {
 
};
// /** @type {import('next').NextConfig} */
// const nextConfig = {
//   transpilePackages: ['@zkpassport/sdk', "@zkpassport/utils"],
//   experimental: {
//     esmExternals: true,
//     outputFileTracingIncludes: {
//       '/api/**/*': [
//         './node_modules/@zkpassport/sdk/**/*',
//         './node_modules/@zkpassport/utils/**/*',
//         './node_modules/@zkpassport/sdk/node_modules/@aztec/bb.js/dest/node/barretenberg_wasm/**/*',
//         './node_modules/@zkpassport/sdk/node_modules/@aztec/bb.js/dest/node/barretenberg_wasm/barretenberg-threads.wasm',
//         './node_modules/@zkpassport/sdk/node_modules/@aztec/bb.js/dest/node/barretenberg_wasm/barretenberg-threads.wasm.gz'
//       ]
//     }
//   },
//   reactStrictMode: false,
//   sassOptions: {
//     includePaths: ['./'],
//   },
//   images: {
//     remotePatterns: [
//       {
//         protocol: 'https',
//         hostname: 'developers.google.com',
//       },
//       {
//         protocol: 'https',
//         hostname: 'img.logo.dev',
//       },
//     ],
//   },
//   env: {
//     NEXT_PUBLIC_GOOGLE_CLIENT_ID: process.env.NEXT_PUBLIC_GOOGLE_CLIENT_ID,
//     NEXT_PUBLIC_SELF_SCOPE_URL: process.env.NEXT_PUBLIC_SELF_SCOPE_URL,
//     NEXT_PUBLIC_SELF_VERIFY_URL: process.env.NEXT_PUBLIC_SELF_VERIFY_URL,
//   },
//   webpack: (config, { isServer }) => {
//     config.experiments = {
//       asyncWebAssembly: true,
//       syncWebAssembly: true,
//       layers: true,
//     };

//     config.module.rules.push({
//       test: /\.wasm$/,
//       type: 'asset/resource'
//     });

//     if (isServer) {
//       config.resolve = {
//         ...config.resolve,
//         alias: {
//           ...config.resolve.alias,
//           '@zkpassport/sdk': '@zkpassport/sdk/dist/esm/index.js'
//         },
//         fallback: {
//           ...config.resolve.fallback,
//           worker_threads: false
//         }
//       };
//       // Set the correct path for vendor chunks
//       config.output = {
//         ...config.output,
//         filename: '[name].js',
//         chunkFilename: 'chunks/[name].js',
//         webassemblyModuleFilename: 'chunks/[modulehash].wasm',
//         globalObject: 'this'
//       };
//     }

//     return config;
//   },
//   eslint: {
//     ignoreDuringBuilds: false,
//   },
//   // async headers() {
//   //   return [
//   //     {
//   //       // Exclude all oauth-callback paths
//   //       source: '/((?!oauth-callback).*)',
//   //       headers: [
//   //         {
//   //           key: 'Cross-Origin-Embedder-Policy',
//   //           value: 'require-corp',
//   //         },
//   //         {
//   //           key: 'Cross-Origin-Opener-Policy',
//   //           value: 'same-origin',
//   //         },
//   //       ],
//   //     },
//   //     {
//   //       // Special case for iOS devices - disable COOP/COEP
//   //       source: '/((?!oauth-callback).*)',
//   //       headers: [
//   //         {
//   //           key: 'Cross-Origin-Embedder-Policy',
//   //           value: 'unsafe-none',
//   //         },
//   //         {
//   //           key: 'Cross-Origin-Opener-Policy',
//   //           value: 'unsafe-none',
//   //         },
//   //       ],
//   //       // Only apply these headers for iOS devices
//   //       has: [
//   //         {
//   //           type: 'header',
//   //           key: 'user-agent',
//   //           value: '(.*iPhone|iPad|iPod.*)',
//   //         },
//   //       ],
//   //     },
//   //   ];
//   // },
// };

export default nextConfig;
