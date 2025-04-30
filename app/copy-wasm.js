import fs from 'fs';
import path from 'path';

const src = path.resolve('node_modules/@zkpassport/sdk/node_modules/@aztec/bb.js/dest/node/barretenberg_wasm/barretenberg-threads.wasm.gz');
const dest = path.resolve('.next/server/vendor-chunks/barretenberg-threads.wasm.gz');

fs.mkdirSync(path.dirname(dest), { recursive: true });

fs.copyFileSync(src, dest);

console.log(`Copied wasm file from ${src} to ${dest}`);
