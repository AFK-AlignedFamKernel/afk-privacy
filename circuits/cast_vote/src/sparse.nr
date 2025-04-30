use dep::std;
use std::hash::poseidon2::Poseidon2::hash;
use trees::{sparse_merkle::SparseMerkleTree, types::{MembershipProver, SMT_Creator}};
use trees::{merkle::MerkleTree};

fn hasher(leaves: [Field; 2]) -> Field {
    hash(leaves, 2)
}

fn leaf_hasher(leaves: [Field; 3]) -> Field {
    hash(leaves, 3)
}

fn main(
    // Old
    root: pub Field,
    index: Field,
    hash_path: [Field; 2],
    secret: Field,
    proposalId: pub Field,
    vote: pub Field,
    proposal_id: pub Field,
    nullifier: pub Field,
    leaf: [Field; 2],
    siblings: [Field; 254],
) -> pub Field {
    let hash3 = |x: [Field; 3]| -> Field { hash(x, 3) };

    // Create a hash function that takes 2 fields and returns a field
    let hash2 = |x: [Field; 2]| -> Field { hash(x, 2) };

    // let mut tree = SparseMerkleTree::new(hash3, hash2);

    // let entry = (leaf[0], leaf[1]);
    // tree.membership(entry, proposal_id, siblings);
    // tree.membership(entry, proposal_id, siblings);

   let mut tree = MerkleTree::new(hash2);

    let entry = (leaf[0], leaf[1]);
    // tree.membership(entry, proposal_id, siblings);
    tree.membership(leaf[0], proposal_id, siblings);


    // Nullifier prevents proposing again
    // let mut mt = MerkleTree::new(hasher);
    // let mut tree = SparseMerkleTree::new(hasher, hasher);
    // tree.membership(hash_path, proposal_id, siblings);

    // Nullifier prevents proposing again
    let computed_nullifier = hash([secret, proposal_id], 2);
    assert(computed_nullifier == nullifier);

    let note_commitment = std::hash::pedersen_hash([secret]);
    let nullifier = std::hash::pedersen_hash([root, secret, proposalId]);

    let check_root = std::merkle::compute_merkle_root(note_commitment, index, hash_path);
    assert(root == check_root);

    // Originally contrained the vote to avoid front-running,
    // but including the vote as a public input is sufficient

    // assert(vote <= 1);

    nullifier
}

// fn main(
//     root: pub Field,
//     index: Field,
//     hash_path: [Field; 2],
//     secret: Field,
//     proposalId: pub Field,
//     vote: pub Field,
//     pub merkle_root: Field,
//     pub proposal_id: Field,
//     pub nullifier: Field,
// ) -> pub Field {
//     let note_commitment = std::hash::pedersen_hash([secret]);
//     let nullifier = std::hash::pedersen_hash([root, secret, proposalId]);

//     let check_root = std::merkle::compute_merkle_root(note_commitment, index, hash_path);
//     assert(root == check_root);

//     // Originally contrained the vote to avoid front-running,
//     // but including the vote as a public input is sufficient

//     // assert(vote <= 1);

//     nullifier
// }

#[test]
fn test_valid_build_merkle_tree() {
    let commitment_0 = std::hash::pedersen_hash([1]);
    let commitment_1 = std::hash::pedersen_hash([2]);
    let commitment_2 = std::hash::pedersen_hash([3]);
    let commitment_3 = std::hash::pedersen_hash([4]);

    let left_branch = std::hash::pedersen_hash([commitment_0, commitment_1]);
    let right_branch = std::hash::pedersen_hash([commitment_2, commitment_3]);

    let root = std::hash::pedersen_hash([left_branch, right_branch]);


    let proposalId = 0;
    let vote = 1;
    let secret = 1;
    let index = 0;
    let hash_path = [commitment_1, right_branch];
    let leaf = commitment_0;
    let mut siblings = [0; 254];
    siblings[0] = commitment_1;
    siblings[1] = right_branch;
   let hash2 = |x: [Field; 2]| -> Field { hash(x, 2) };
    
  // Initialize the tree
    let mut tree = MerkleTree::new(hash2);

    let nullifier = main(
        root,
        index,
        hash_path,
        secret,
        proposalId,
        vote,
        proposalId,
        std::hash::pedersen_hash([secret, proposalId]),
        hash_path,
        siblings,
    );

    let expected_nullifier = std::hash::pedersen_hash([root, secret, proposalId]);

    std::println("Merkle Tree:");
    std::println([root]);
    std::println([left_branch, right_branch]);
    std::println([commitment_0, commitment_1, commitment_2, commitment_3]);

    assert(nullifier == expected_nullifier);
}

// fn main(root : pub Field, index : Field, hash_path : [Field; 2], secret: Field, priv_key: Field, proposalId: pub Field, vote: pub u8) -> pub Field {
//     let note_commitment = std::hash::pedersen([priv_key, secret]);
//     let nullifier = std::hash::pedersen([root, priv_key, proposalId]);

//     let check_root = std::merkle::compute_merkle_root(note_commitment[0], index, hash_path);
//     assert(root == check_root);

//     // Originally contrained the vote to avoid front-running,
//     // but including the vote as a public input is sufficient

//     assert(vote <= 1);

//     nullifier[0]
// }

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

#[test]
fn test_sparse_merkle_tree() {
    // Create hash functions for the tree
    let hash3 = |x: [Field; 3]| -> Field { hash(x, 3) };
    let hash2 = |x: [Field; 2]| -> Field { hash(x, 2) };

    // Initialize the tree
    let mut tree = SparseMerkleTree::new(hash3, hash2);

    // Create a leaf entry (commitment pair)
    let secret = 1;
    let value = 100;
    let entry = (secret, value);
    
    // Create proposal ID and hash path
    let proposal_id = 1;
    let hash_path = [secret, value];
    
    // Create siblings for the proof
    let mut siblings = [0; 254];
    
    // Calculate note commitment and root
    let note_commitment = std::hash::pedersen_hash([secret]);
    let root = std::merkle::compute_merkle_root(note_commitment, 0, hash_path);
    
    // Calculate nullifier as per main function
    let nullifier = std::hash::pedersen_hash([root, secret, proposal_id]);
    
    // Test the main function with the same parameters as used in the original test
    let result = main(
        root,      // root
        0,         // index
        hash_path,
        secret,
        proposal_id,
        1,         // vote
        proposal_id,
        nullifier,
        hash_path, // leaf
        siblings
    );

    // The expected nullifier should match what we calculated
    assert(result == nullifier);
}
