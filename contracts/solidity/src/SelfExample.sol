import {SelfVerificationRoot} from "@selfxyz/contracts/contracts/abstract/SelfVerificationRoot.sol";
import {ISelfVerificationRoot} from "@selfxyz/contracts/contracts/interfaces/ISelfVerificationRoot.sol";

contract SelfExample is SelfVerificationRoot {
    constructor(
        address _identityVerificationHub,
        uint256 _scope, 
        uint256[] memory _attestationIds,
    ) 
        SelfVerificationRoot(
            _identityVerificationHub, // Address of our Verification Hub, e.g., "0x77117D60eaB7C044e785D68edB6C7E0e134970Ea"
            _scope, // An application-specific identifier for the integrated contract
            _attestationIds[], // The id specifying the type of document to verify (e.g., 1 for passports)
        )
    {} 
    
    function verifySelfProof(
        ISelfVerificationRoot.DiscloseCircuitProof memory proof
    ) 
        public 
        override 
    {
        super.verifySelfProof(proof);
    }
}