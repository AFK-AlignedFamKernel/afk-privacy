// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import "forge-std/Script.sol";
import "../src/zkVote.sol";
import {HonkVerifier as VerifierPropose} from "../src/verifiers/VerifierPropose.sol";
import {HonkVerifier as VerifierVote} from "../src/verifiers/VerifierVote.sol";

contract DeploymentScript is Script {
    function readInputs() internal view returns (string memory) {
        string memory inputDir = string.concat(vm.projectRoot(), "/data/input");

        return vm.readFile(string.concat(inputDir, ".json"));
    }

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);

        VerifierPropose verifierPropose = new VerifierPropose();
        VerifierVote verifierVote = new VerifierVote();

        string memory inputs = readInputs();

        bytes memory merkleRoot = vm.parseJson(inputs, ".merkleRoot");
        bytes memory merkleRootPropose = vm.parseJson(inputs, ".merkleRootPropose");
        bytes memory nullifierHash = vm.parseJson(inputs, ".nullifierHash");
        bytes memory nullifierHashPropose = vm.parseJson(inputs, ".nullifierHashPropose");

        zkVote voting = new zkVote(bytes32(merkleRoot), bytes32(merkleRootPropose), address(verifierPropose), address(verifierVote));

        vm.stopBroadcast();
    }
}