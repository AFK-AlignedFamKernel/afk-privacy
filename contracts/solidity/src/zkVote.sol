// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import "./verifiers/VerifierPropose.sol";
import "./verifiers/VerifierVote.sol";

contract zkVote {
    VerifierPropose public verifierPropose;
    VerifierVote public verifierVote;

    bytes32 public voterMerkleRoot;
    bytes32 public proposerMerkleRoot;

    uint256 public proposalCount;
    uint256 public constant CREATOR_REWARD = 0.01 ether;

    struct Proposal {
        string description;
        uint256 deadline;
        uint256 forVotes;
        uint256 againstVotes;
        address creator;         // optional — not used in ZK claim
        bool rewardClaimed;
    }

    mapping(uint256 => Proposal) public proposals;

    mapping(bytes32 => bool) public voteNullifiers;
    mapping(bytes32 => bool) public proposeNullifiers;

    event ProposalCreated(uint256 indexed proposalId, string description, uint256 deadline);
    event VoteCast(uint256 indexed proposalId, bool vote);

    constructor(bytes32 _proposerMerkleRoot, bytes32 _voterMerkleRoot, address _verifierPropose, address _verifierVote) {
        proposerMerkleRoot = _proposerMerkleRoot;
        voterMerkleRoot = _voterMerkleRoot;
        verifierPropose = VerifierPropose(_verifierPropose);
        verifierVote = VerifierVote(_verifierVote);
    }

    /// Cast a private proposal using a Noir circuit
    /// publicInputs: [proposerMerkleRoot, proposalId, nullifier]
    function castPropose(bytes calldata proof, bytes32[] calldata publicInputs, string calldata description, uint256 deadline)
        external
        returns (uint256)
    {
        require(publicInputs.length == 3, "Invalid inputs");

        bytes32 root = publicInputs[0];
        uint256 proposalId = uint256(publicInputs[1]);
        bytes32 nullifier = publicInputs[2];

        require(root == proposerMerkleRoot, "Invalid proposer Merkle root");
        require(!proposeNullifiers[nullifier], "Propose nullifier used");
        require(deadline > block.timestamp, "Deadline must be in future");

        require(verifierPropose.verify(proof, publicInputs), "Invalid propose proof");

        proposeNullifiers[nullifier] = true;

        proposals[proposalId] = Proposal({
            description: description,
            deadline: deadline,
            forVotes: 0,
            againstVotes: 0,
            creator: address(0), // optional
            rewardClaimed: false
        });

        emit ProposalCreated(proposalId, description, deadline);
        return proposalId;
    }

    /// Cast a private vote using a Noir circuit
    /// publicInputs: [voterMerkleRoot, proposalId, vote, nullifier]
    function castVote(bytes calldata proof, bytes32[] calldata publicInputs)
        external
        returns (bool)
    {
        require(publicInputs.length == 4, "Invalid inputs");

        bytes32 root = publicInputs[0];
        uint256 proposalId = uint256(publicInputs[1]);
        uint256 vote = uint256(publicInputs[2]);
        bytes32 nullifier = publicInputs[3];

        require(root == voterMerkleRoot, "Invalid voter Merkle root");
        require(!voteNullifiers[nullifier], "Vote nullifier used");
        require(proposalId < proposalCount, "Invalid proposal");
        require(block.timestamp < proposals[proposalId].deadline, "Voting closed");
        require(vote == 0 || vote == 1, "Invalid vote");

        require(verifierVote.verify(proof, publicInputs), "Invalid vote proof");

        voteNullifiers[nullifier] = true;

        if (vote == 1) {
            proposals[proposalId].forVotes++;
        } else {
            proposals[proposalId].againstVotes++;
        }

        emit VoteCast(proposalId, vote == 1);
        return true;
    }

    receive() external payable {}
}
