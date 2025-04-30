import { useState } from "react";
import ZkPassportRegistration from "@/components/zkdid/zk-passport";
import SelfXyzRegistration from "@/components/zkdid/self-xyz";

type Provider = 'self' | 'zkpassport';

function ZkIdentityComponent() {
    const [selectedProvider, setSelectedProvider] = useState<Provider>('zkpassport');

    return (
        <div className="identity-verification">
            <h2>Identity Verification</h2>

            <div className="provider-tabs">

                <button
                    className={`tab-button ${selectedProvider === 'zkpassport' ? 'active' : ''}`}
                    onClick={() => setSelectedProvider('zkpassport')}
                >
                    ZKPassport
                </button>
                <button
                    className={`tab-button ${selectedProvider === 'self' ? 'active' : ''}`}
                    onClick={() => setSelectedProvider('self')}
                >
                    SelfXYZ
                </button>
            </div>

            <div className="verification-container">
                {selectedProvider === 'self' ? (
                    <SelfXyzRegistration />
                ) : (
                    <ZkPassportRegistration />
                )}
            </div>
        </div>
    );
}

export default ZkIdentityComponent;