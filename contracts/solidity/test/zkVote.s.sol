// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/zkVote.sol";
import {HonkVerifier as VerifierPropose} from "../src/verifiers/VerifierPropose.sol";
import {HonkVerifier as VerifierVote} from "../src/verifiers/VerifierVote.sol";

contract VotingTest is Test {
    zkVote public voteContract;
    VerifierPropose public verifierPropose;
    VerifierVote public verifierVote;

    bytes proofBytes;
    uint256 deadline = block.timestamp + 10000000;

    bytes32 merkleRoot;
    bytes32 nullifierHash;

    bytes32 merkleRootPropose;
    bytes32 nullifierHashPropose;
    function readInputs() internal view returns (string memory) {
        string memory inputDir = string.concat(vm.projectRoot(), "/data/input");
        return vm.readFile(string.concat(inputDir, ".json"));
    }

    function setUp() public {
        string memory inputs = readInputs();

        merkleRoot = bytes32(vm.parseJson(inputs, ".merkleRoot"));
        nullifierHash = bytes32(vm.parseJson(inputs, ".nullifierHash"));

        merkleRootPropose = bytes32(vm.parseJson(inputs, ".merkleRootPropose"));
        nullifierHashPropose = bytes32(vm.parseJson(inputs, ".nullifierHashPropose"));

        verifierPropose = new VerifierPropose();
        verifierVote = new VerifierVote();
        voteContract = new zkVote(merkleRoot, merkleRootPropose, address(verifierPropose), address(verifierVote));
        voteContract.propose("First proposal", deadline);

        // string memory proofFilePath = "../../circuits/zk_vote/target/proof/calldata.txt";
        // string memory proofFilePath = "../../circuits/cast_vote/target/proof/proof";
        string memory proofFilePath = "../../circuits/cast_vote/target/proof/proof";
        // string memory proofFilePath = "../../circuits/zk_vote/target/proof/proof";
        string memory proofData = vm.readLine(proofFilePath);
        proofBytes = vm.parseBytes(proofData);
    }

    function test_validVote() public {

        bytes32[] memory publicInputs = new bytes32[](3);
        publicInputs[0] = merkleRoot;
        publicInputs[1] = bytes32(0);
        publicInputs[2] = nullifierHashPropose; 
        voteContract.castVote(proofBytes, publicInputs);

        // voteContract.castVote(proofBytes, 0, 1, nullifierHash);
    }

    function test_invalidProof() public {
        vm.expectRevert();
        // voteContract.castVote(hex"12", 0, 1, nullifierHash);
    }

    function test_doubleVoting() public {
        // voteContract.castPropose(proofBytes, 0, 0, nullifierHashPropose);

        bytes32[] memory publicInputs = new bytes32[](3);
        publicInputs[0] = merkleRoot;
        publicInputs[1] = bytes32(0);
        publicInputs[2] = nullifierHashPropose; 

        vm.expectRevert("Proof has been already submitted");
        voteContract.castVote(proofBytes, publicInputs);
    }

    function test_changedVote() public {
        vm.expectRevert();
   bytes32[] memory publicInputs = new bytes32[](3);
        publicInputs[0] = merkleRoot;
        publicInputs[1] = bytes32(0);
        publicInputs[2] = nullifierHashPropose; 
        voteContract.castVote(proofBytes, publicInputs);

        // voteContract.castVote(proofBytes, 0, 0, nullifierHash);
    }
}