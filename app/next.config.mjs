import dotenv from 'dotenv';
import webpack from 'webpack';

dotenv.config();

/** @type {import('next').NextConfig} */
const nextConfig = {
  transpilePackages: ['@zkpassport/sdk', '@zkpassport/utils'],
  experimental: {
    outputFileTracingIncludes: {
      '/api/messages': [
        './node_modules/@aztec/bb.js/dest/node/barretenberg_wasm/**/*',
        './node_modules/@aztec/bb.js/dest/node/barretenberg_wasm/barretenberg_wasm_thread/factory/node/thread.worker.js'
      ],
      '/api/messages/': [
        './node_modules/@aztec/bb.js/dest/node/barretenberg_wasm/**/*',
        './node_modules/@aztec/bb.js/dest/node/barretenberg_wasm/barretenberg_wasm_thread/factory/node/thread.worker.js'
      ],
    },
    esmExternals: true // Enable ESM support
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
    NEXT_PUBLIC_SELF_SCOPE_URL: process.env.NEXT_PUBLIC_SELF_SCOPE_URL,
    NEXT_PUBLIC_SELF_VERIFY_URL: process.env.NEXT_PUBLIC_SELF_VERIFY_URL,
  },
  webpack: (config, { isServer }) => {
    config.experiments = {
      asyncWebAssembly: true,
      syncWebAssembly: true,
      layers: true,
    };

    // Add configuration for @zkpassport
    // config.resolve = {
    //   ...config.resolve,
    //   alias: {
    //     ...config.resolve.alias,
    //     '@zkpassport/utils': '@zkpassport/utils/dist/cjs',
    //     '@zkpassport/sdk': '@zkpassport/sdk/dist/cjs',
    //   },
    //   fallback: {
    //     ...config.resolve.fallback,
    //     fs: false,
    //     net: false,
    //     tls: false,
    //   },
    //   extensionAlias: {
    //     '.js': ['.js', '.ts', '.tsx']
    //   }
    // };

    // Handle CommonJS modules in client-side code
    // if (!isServer) {
    //   config.module = {
    //     ...config.module,
    //     rules: [
    //       ...config.module.rules,
    //       {
    //         test: /\.(js|mjs|cjs)$/,
    //         include: /node_modules\/@zkpassport/,
    //         use: {
    //           loader: 'babel-loader',
    //           options: {
    //             presets: ['next/babel'],
    //             plugins: ['@babel/plugin-transform-modules-commonjs']
    //           }
    //         }
    //       },
    //       {
    //         test: /\.m?js$/,
    //         type: 'javascript/auto',
    //         resolve: {
    //           fullySpecified: false
    //         }
    //       }
    //     ]
    //   };
    // }

    return config;
  },
  eslint: {
    ignoreDuringBuilds: false,
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
