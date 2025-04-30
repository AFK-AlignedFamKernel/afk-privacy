import { ZKPassport } from '@zkpassport/sdk/dist/esm/index.js';
// import { ZKPassport } from '@zkpassport/sdk/dist/cjs/index.js';
// import { ZKPassport } from '@zkpassport/sdk/dist/esm/index.js';
// import { ZKPassport } from '@zkpassport/sdk';
let zkPassportInstance: ZKPassport | null = null;

export async function getZKPassport() {
    if (!zkPassportInstance) {
        try {
            // zkPassportInstance = ZKPassport;
            zkPassportInstance = await import('@zkpassport/sdk/dist/esm/index.js');
        } catch (error) {
            console.error('Failed to import ZKPassport:', error);
            throw error;
        }
    }
    return zkPassportInstance;
}

export async function createZKPassportInstance(domainUrl: string) {
    const ZKPassportClass = await getZKPassport();
    if (!ZKPassportClass) {
        throw new Error('ZKPassport not initialized');
    }
    return new ZKPassportClass(domainUrl);
}

export { ZKPassport }; 