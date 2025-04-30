import dotenv from 'dotenv';
import webpack from 'webpack';
import { createRequire } from 'module';

const require = createRequire(import.meta.url);

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
  webpack: (config) => {
    config.experiments = {
      asyncWebAssembly: true,
      syncWebAssembly: true,
      layers: true,
      topLevelAwait: true,
    };
    // Handle WASM files
    config.module.rules.push({
      test: /\.wasm(\.gz)?$/,
      type: 'asset/resource',
      generator: {
        filename: 'static/wasm/[name][ext]'
      }
    });

    // Handle worker files
    // config.module.rules.push({
    //   test: /\.worker\.js$/,
    //   type: 'asset/resource',
    //   generator: {
    //     filename: 'static/workers/[name][ext]'
    //   }
    // });

    // Force CommonJS for problematic packages
    config.module.rules.push({
      test: /node_modules\/@zkpassport\/utils\/.*\.js$/,
      type: 'javascript/auto',
      resolve: {
        fullySpecified: false
      }
    });
    // Preserve paths for @zkpassport packages
    config.resolve = {
      ...config.resolve,
      alias: {
        ...config.resolve.alias,
        '@zkpassport/sdk': require.resolve('@zkpassport/sdk'),
        '@zkpassport/utils': require.resolve('@zkpassport/utils')
      }
    };

    if (isServer) {
      config.resolve = {
        ...config.resolve,
        fallback: {
          ...config.resolve.fallback,
          worker_threads: false,
        }
      };
    }

    return config
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