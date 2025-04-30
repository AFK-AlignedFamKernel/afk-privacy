import dotenv from 'dotenv';
import webpack from 'webpack';

dotenv.config();

/** @type {import('next').NextConfig} */
const nextConfig = {
  transpilePackages: ['@zkpassport/sdk', "@aztec/bb.js", "@zkpassport/utils"],
  experimental: {
    esmExternals: 'loose',
    outputFileTracingIncludes: {
      '/api/**/*': [
        './node_modules/@zkpassport/sdk/**/*',
        './node_modules/@aztec/bb.js/**/*',
        './node_modules/@zkpassport/utils/**/*',
        './node_modules/@aztec/bb.js/**/*',
      ]
    }
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
      layers: true,
      // syncWebAssembly: true,
      // topLevelAwait: true,
    };

 
    // Handle WASM files
    config.module.rules.push({
      test: /\.wasm(\.gz)?$/,
      type: 'asset/resource',
      generator: {
        filename: '[name][ext]' // Keep original filename and path
      }
    });

    // Handle worker files
    config.module.rules.push({
      test: /\.worker\.js$/,
      type: 'asset/resource',
      generator: {
        filename: '[name][ext]' // Keep original filename and path
      }
    });

    // Properly handle ESM in Node.js environment
    if (isServer) {
      config.resolve.fallback = {
        ...config.resolve.fallback,
        worker_threads: false,
      };

      // Preserve the original file structure
      config.output = {
        ...config.output,
        assetModuleFilename: '[name][ext]',
      };
    }

    // config.module.rules.push({
    //   test: /\.worker\.js$/,
    //   type: 'asset/resource',
    //   generator: {
    //     filename: 'static/workers/[name][ext]'
    //   }
    // });

    // if (isServer) {
    //   config.resolve = {
    //     ...config.resolve,
    //     fallback: {
    //       ...config.resolve.fallback,
    //       worker_threads: false
    //     }
    //   };
    // }

    // // Ensure clean output paths
    // config.output = {
    //   ...config.output,
    //   assetModuleFilename: 'static/assets/[name][ext]',
    //   clean: true
    // };
    // Add resolve aliases to ensure correct paths
    config.resolve.alias = {
      ...config.resolve.alias,
    };

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