import dotenv from 'dotenv';
import webpack from 'webpack';
import path from 'path';

dotenv.config();

/** @type {import('next').NextConfig} */
const nextConfig = {
  transpilePackages: ['@zkpassport/sdk', '@zkpassport/utils'],
  experimental: {
    esmExternals: true,
    outputFileTracingIncludes: {
      '/api/**/*': [
        './node_modules/@zkpassport/sdk/**/*',
        './node_modules/@zkpassport/utils/**/*',
        './node_modules/@aztec/bb.js/**/*',
        './node_modules/@zkpassport/sdk/node_modules/@aztec/bb.js/dest/node/**/*',
        './node_modules/@zkpassport/sdk/node_modules/@aztec/bb.js/**/*',
        './node_modules/@zkpassport/sdk/node_modules/@aztec/bb.js/dest/node/barretenberg_wasm/**/*',
        './node_modules/@zkpassport/sdk/node_modules/@aztec/bb.js/dest/node/barretenberg_wasm/barretenberg_wasm_thread/factory/node/thread.worker.js',
        './node_modules/@aztec/bb.js/dest/node/barretenberg_wasm/barretenberg_wasm_thread/factory/node/thread.worker.js',
        './node_modules/@aztec/bb.js/dest/node/barretenberg_wasm/**/*',
      ]
    }
  },
  webpack: (config, { isServer }) => {
    config.experiments = {
      ...config.experiments,
      asyncWebAssembly: true,
      syncWebAssembly: true,
      layers: true,
      topLevelAwait: true,
    };

    // // Handle WASM files
    config.module.rules.push({
      test: /\.wasm$/,
      type: 'asset/resource',
      generator: {
        // filename: 'server/vendor-chunks/[name][ext]' // Match the expected path
        filename: 'static/wasm/[name][ext]'
      }
    });


    // Handle worker files
    config.module.rules.push({
      test: /\.worker\.(js|ts)$/,
      use: {
        loader: 'worker-loader',
        options: {
          filename: isServer
            ? '../vendor-chunks/[name].js'  // relative to .next/server/pages/api
            : 'static/workers/[name].[contenthash].js',
          // filename: 'static/chunks/[name].[contenthash].worker.js',
          // filename: 'server/vendor-chunks/[name]', // Match the expected path
          // publicPath: '/_next/'
        }
      }
    });


    // // Handle worker files
    // config.module.rules.push({
    //   test: /\.worker\.js$/,
    //   use: {
    //     loader: 'worker-loader',
    //     options: {
    //       filename: 'vendor-chunks/[name].js'
    //     }
    //   }
    // });

    if (isServer) {
      config.resolve = {
        ...config.resolve,
        alias: {
          ...config.resolve.alias,
          '@zkpassport/sdk': '@zkpassport/sdk/dist/esm/index.js'
        },
        // Disable worker_threads on server
        fallback: {
          ...config.resolve.fallback,
          worker_threads: false,
          // fs: false,
          // net: false,
          // tls: false
        }
      };

      // Set output path for workers
      // config.output = {
      //   ...config.output,
      //   filename: '[name].js',
      //   chunkFilename: 'vendor-chunks/[name].js',
      //   // webassemblyModuleFilename: 'vendor-chunks/[modulehash].wasm'
      //   // filename: '[name].js',
      //   // chunkFilename: 'vendor-chunks/[name].js',
      //   // webassemblyModuleFilename: 'static/wasm/[modulehash].wasm'
      // };
    }

    return config;
  }
};

export default nextConfig;
