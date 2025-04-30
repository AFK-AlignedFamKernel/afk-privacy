import dotenv from 'dotenv';
import webpack from 'webpack';
import { createRequire } from 'module';

const require = createRequire(import.meta.url);

dotenv.config();

/** @type {import('next').NextConfig} */
const nextConfig = {
  transpilePackages: ['@zkpassport/sdk'],
  experimental: {
    esmExternals: 'loose',
    // esmExternals: true,
    // serverComponentsExternalPackages: ['@zkpassport/sdk', '@zkpassport/utils'],
    outputFileTracingIncludes: {
      '/api/**/*': [
        './node_modules/@zkpassport/sdk/**/*',
        './node_modules/@zkpassport/utils/**/*',
        './node_modules/@aztec/bb.js/**/*'
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
      syncWebAssembly: true,
      layers: true,
    };

    // Force CJS for @zkpassport/utils
    config.module.rules.push({
      test: /node_modules\/@zkpassport\/utils\/.*\.js$/,
      // type: 'esm',
    });


    // Handle WASM files
    config.module.rules.push({
      test: /\.wasm$/,
      type: 'asset/resource'
    });

    // Handle worker files
    config.module.rules.push({
      test: /\.worker\.js$/,
      type: 'asset/resource',
      generator: {
        filename: 'static/workers/[name][ext]'
      }
    });

    if (isServer) {
      config.resolve.fallback = {
        ...config.resolve.fallback,
        worker_threads: false,
        fs: false,
        net: false,
        tls: false,
      };
    }

    return config;
  },
  eslint: {
    ignoreDuringBuilds: false,
  },
  // Enable CORS headers for WASM loading
  async headers() {
    return [
      {
        source: '/static/wasm/:path*',
        headers: [
          {
            key: 'Cross-Origin-Embedder-Policy',
            value: 'require-corp',
          },
          {
            key: 'Cross-Origin-Opener-Policy',
            value: 'same-origin',
          },
        ],
      },
    ];
  },
};

export default nextConfig;