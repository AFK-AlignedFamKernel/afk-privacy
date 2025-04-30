import { pathToFileURL } from 'url';

export async function loadESModule(modulePath: string) {
    try {
        const moduleUrl = pathToFileURL(modulePath).href;
        return await import(moduleUrl);
    } catch (error) {
        console.error(`Failed to load module ${modulePath}:`, error);
        throw error;
    }
} 