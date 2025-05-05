use dep::std;
use std::hash::poseidon2::Poseidon2::hash;
use trees::{types::{Calculator, MT_Creator}, merkle::MerkleTree};


pub fn verify_merkle_tree_vote(
    root: pub Field,
    index: Field,
    hash_path: [Field; 2],
    secret: Field,
    proposal_id: pub Field,
    vote: pub Field,
    leaf: Field,
    nullifier: pub Field,
) -> pub Field {
    let hash2 = |x: [Field; 2]| -> Field { hash(x, 2) };

    let mut tree = MerkleTree::new(hash2);

    let root_check = tree.calculate_root(leaf, index, hash_path);
    assert(root_check == root);

    // assert(vote == 0 || vote == 1);

    let expected_nullifier = std::hash::pedersen_hash([root, secret, proposal_id]);
    assert(nullifier == expected_nullifier);


    expected_nullifier


}

#[test]
fn test_valid_build_merkle_tree() {
    let secret = 9;
    let commitment_0 = std::hash::pedersen_hash([0, secret]);
    let commitment_1 = std::hash::pedersen_hash([1, secret]);
    let commitment_2 = std::hash::pedersen_hash([2, secret]);
    let commitment_3 = std::hash::pedersen_hash([3, secret]);

    let hash2 = |x: [Field; 2]| -> Field { hash(x, 2) };
    let mut tree = MerkleTree::new(hash2);

    let left_branch = hash2([commitment_0, commitment_1]);
    let right_branch = hash2([commitment_2, commitment_3]);

    let root = hash2([left_branch, right_branch]);

    let index = 0;
    let hash_path = [commitment_1, right_branch];
    let proposal_id = 1;
    let vote = 1;
    let nullifier = std::hash::pedersen_hash([root, secret, proposal_id]);
    
    let nullifier = verify_merkle_tree_vote(
        root,
        index,
        hash_path,
        secret,
        proposal_id,
        vote,
        commitment_0,
        nullifier
    );

    let expected_nullifier = std::hash::pedersen_hash([root, secret, proposal_id]);

    std::println("Merkle Tree Structure:");
    std::println([root]);
    std::println([left_branch, right_branch]);
    std::println([commitment_0, commitment_1, commitment_2, commitment_3]);

    assert(nullifier == expected_nullifier);

    let calculated_root = tree.calculate_root(commitment_0, index, hash_path);
    assert(calculated_root == root);
}



// Helpers for getting note_commitments to build the merkle tree.
// To view: nargo test --show-output

#[test]
fn test_build_merkle_tree() {
    let secret = 9;
    let commitment_0 = std::hash::pedersen_hash([0, secret]);
    let commitment_1 = std::hash::pedersen_hash([1, secret]);
    let commitment_2 = std::hash::pedersen_hash([2, secret]);
    let commitment_3 = std::hash::pedersen_hash([3, secret]);

    let left_branch = std::hash::pedersen_hash([commitment_0, commitment_1]);
    let right_branch = std::hash::pedersen_hash([commitment_2, commitment_3]);

    let root = std::hash::pedersen_hash([left_branch, right_branch]);

    std::println("Merkle Tree:");
    std::println([root]);
    std::println([left_branch, right_branch]);
    std::println([commitment_0, commitment_1, commitment_2, commitment_3]);
}


