use dep::std;
use std::hash::poseidon2::Poseidon2::hash;
use trees::merkle::MerkleTree;
use trees::{sparse_merkle::{SparseMerkleTree, Modifier}, types::{Calculator, MembershipProver, SMT_Creator}};

fn hasher(leaves: [Field; 2]) -> Field {
    hash(leaves, 2)
}

fn leaf_hasher(leaves: [Field; 3]) -> Field {
    hash(leaves, 3)
}

// fn main(
//     root: pub Field,
//     secret: Field,
//     proposal_id: pub Field,
//     vote: pub Field,
//     nullifier_default: pub Field,
//     leaf: [Field; 2],
//     siblings: [Field; 254],
// ) -> pub Field {
//     let hash2 = |x: [Field; 2]| -> Field { hash(x, 2) };
//     let hash3 = |x: [Field; 3]| -> Field { hash(x, 3) };

//     let mut tree = SparseMerkleTree::new(hash3, hash2);

//     let key = leaf[0];
//     let value = leaf[1];    
//     let entry = (key, value);
//     // let note_commitment = std::hash::pedersen_hash([secret]);
//     let nullifier = std::hash::pedersen_hash([root, secret, proposal_id]);


//     // Calculate and verify root
//     // tree.membership(entry, key, siblings);
   
//     let root_check = tree.calculate_root(entry, key, siblings);
//     assert(root_check == root);

//     let entry = (leaf[0], leaf[1]);
//     let calculated_root = tree.calculate_root(entry, leaf[0], siblings);
//     assert(calculated_root == root);


//     // 2. Verify nullifier is correct (prevents double voting)
//     let expected_nullifier = std::hash::pedersen_hash([secret, proposal_id]);
//     assert(expected_nullifier == nullifier);


//     // 3. Verify vote is valid (e.g., 0 or 1 for yes/no)
//     // assert(vote == 0 || vote == 1);

//     // Verify nullifier
//     let computed_nullifier = std::hash::pedersen_hash([secret, proposal_id]);
//     assert(computed_nullifier == nullifier);

//     // Return the commitment
//     std::hash::pedersen_hash([root, secret, proposal_id])
// }
pub fn verify_vote(
    root: pub Field,
    secret: Field,
    proposal_id: pub Field,
    vote: pub Field,
    nullifier_default: pub Field,
    leaf: [Field; 2],
    siblings: [Field; 254],
) -> pub Field {
    let hash2 = |x: [Field; 2]| -> Field { hash(x, 2) };
    let hash3 = |x: [Field; 3]| -> Field { hash(x, 3) };

    let mut tree = SparseMerkleTree::new(hash3, hash2);

    let key = leaf[0];
    let value = leaf[1];    
    let entry = (key, value);
    // let note_commitment = std::hash::pedersen_hash([secret]);
    // let nullifier = std::hash::pedersen_hash([root, secret, proposal_id]);


    // Calculate and verify root
    // tree.membership(entry, key, siblings);
   
    let root_check = tree.calculate_root(entry, key, siblings);
    assert(root_check == root);

    // Verify nullifier
    let computed_nullifier = std::hash::pedersen_hash([secret, proposal_id]);
    assert(computed_nullifier == nullifier_default);

    // Return the commitment
    std::hash::pedersen_hash([root, secret, proposal_id])
}


fn main(
    root: pub Field,
    secret: Field,
    proposal_id: pub Field,
    vote: pub Field,
    nullifier_default: pub Field,
    leaf: [Field; 2],
    siblings: [Field; 254],
) -> pub Field {
    let hash2 = |x: [Field; 2]| -> Field { hash(x, 2) };
    let hash3 = |x: [Field; 3]| -> Field { hash(x, 3) };

    let mut tree = SparseMerkleTree::new(hash3, hash2);

    let key = leaf[0];
    let value = leaf[1];    
    let entry = (key, value);
    // let note_commitment = std::hash::pedersen_hash([secret]);
    // let nullifier = std::hash::pedersen_hash([root, secret, proposal_id]);


    // Calculate and verify root
    // tree.membership(entry, key, siblings);
   
    let root_check = tree.calculate_root(entry, key, siblings);
    assert(root_check == root);

    // Verify nullifier
    let computed_nullifier = std::hash::pedersen_hash([secret, proposal_id]);
    assert(computed_nullifier == nullifier_default);

    // Return the commitment
    std::hash::pedersen_hash([root, secret, proposal_id])
}

#[test]
fn test_valid_sparse_merkle_tree_membership() {
    let hash2 = |x: [Field; 2]| -> Field { hash(x, 2) };
    let hash3 = |x: [Field; 3]| -> Field { hash(x, 3) };

    // Create a simple tree structure
    let key = 12345;
    let value = 999;
    let entry = (key, value);
    
    // Initialize tree
    let mut tree = SparseMerkleTree::new(hash3, hash2);
    
    // Create siblings array with default values
    let mut siblings = [0; 254];
    
    // Calculate leaf hash
    let leaf_hash = hash3([key, value, 0]);
    
    // Calculate the first level sibling
    siblings[0] = hash3([0, 0, 1]);
    
    // Calculate intermediate nodes
    let mut current_hash = leaf_hash;
    for i in 0..3 {  // We'll create a small subtree for testing
        current_hash = hash2([current_hash, siblings[i]]);
        if i + 1 < 3 {
            siblings[i + 1] = hash2([0, 0]);  // Default sibling for next level
        }
    }
    
    // The final hash becomes our root
    let root = current_hash;
    
    // Create vote parameters
    let secret = 777;
    let proposal_id = 1;
    let vote = 1;
    let leaf = [key, value];
    
    // Calculate nullifier
    let nullifier = std::hash::pedersen_hash([secret, proposal_id]);
    // Execute the main circuit
    let result = main(
        root,
        secret,
        proposal_id,
        vote,
        nullifier,
        leaf,
        siblings
    );
    
    // Calculate expected output
    let expected_output = std::hash::pedersen_hash([root, secret, proposal_id]);
    assert(result == expected_output);
}

// #[test]
// fn test_valid_sparse_merkle_tree_membership() {
//     // let poseidon2 = std::hash::poseidon2::Poseidon2 {};
//     let hash2 = |x: [Field; 2]| -> Field { hash(x, 2) };
//     let hash3 = |x: [Field; 3]| -> Field { hash(x, 3) };

//     // Let's use a dummy key-value pair
//     let key = 12345;
//     let value = 999;
//     let leaf = [key, value];

//     // Build the SMT
//     let mut tree = SparseMerkleTree::new(hash3, hash2);
//     let entry = (key, value);

//     // NOTE: tree.insert() must happen **outside ZK circuit** (trusted setup)
//     // let siblings = tree.add(entry, key);

//  let commitment_0 = std::hash::pedersen_hash([1]);
//     let commitment_1 = std::hash::pedersen_hash([2]);
    
//       let commitment_2 = std::hash::pedersen_hash([3]);
//     let commitment_3 = std::hash::pedersen_hash([4]);

//      let left_branch = std::hash::pedersen_hash([commitment_0, commitment_1]);
//     let right_branch = std::hash::pedersen_hash([commitment_2, commitment_3]);

//     let root = std::hash::pedersen_hash([left_branch, right_branch]);

//     let vote = 1;
//     let secret: Field = 1;
//     let hash_path = [commitment_1, right_branch];
//     let leaf = commitment_0;
//     let mut siblings = [0; 254];
//     siblings[0] = commitment_1;
//     siblings[1] = right_branch;
//     let root = tree.calculate_root(entry, key, siblings);

//     // Create vote identity
//     let secret = 777;
//     let proposal_id = 1;
//     let vote = 1;

//     // Construct the nullifier (public) and return value
//     let nullifier = std::hash::pedersen_hash([secret, proposal_id]);
//     let expected_output = std::hash::pedersen_hash([root, secret, proposal_id]);

//     // Now invoke the ZK function
//     let result = main(
//         root,
//         0,
//         secret,
//         proposal_id,
//         vote,
//         nullifier,
//         hash_path,
//         siblings,
//     );

//     assert(result == expected_output);
// }



// // #[test]
// fn test_valid_build_merkle_tree() {
//     let commitment_0 = std::hash::pedersen_hash([1]);
//     let commitment_1 = std::hash::pedersen_hash([2]);
//     let commitment_2 = std::hash::pedersen_hash([3]);
//     let commitment_3 = std::hash::pedersen_hash([4]);

//     let left_branch = std::hash::pedersen_hash([commitment_0, commitment_1]);
//     let right_branch = std::hash::pedersen_hash([commitment_2, commitment_3]);

//     let root = std::hash::pedersen_hash([left_branch, right_branch]);

//     let proposalId = 0;
//     let vote = 1;
//     let secret = 1;
//     let index = 0;
//     let hash_path = [commitment_1, right_branch];
//     let leaf = commitment_0;
//     let mut siblings = [0; 254];
//     siblings[0] = commitment_1;
//     siblings[1] = right_branch;
//     let hash2 = |x: [Field; 2]| -> Field { hash(x, 2) };
//     let hash3 = |x: [Field; 3]| -> Field { hash(x, 3) };
//     // Initialize the tree
//     // let mut tree = MerkleTree::new(hash2);

//     let mut tree = SparseMerkleTree::new(hash3, hash2);
//     let nullifier = main(
//         root,
//         index,
//         hash_path,
//         secret,
//         proposalId,
//         vote,
//         proposalId,
//         std::hash::pedersen_hash([secret, proposalId]),
//         hash_path,
//         siblings,
//     );

//     let expected_nullifier = std::hash::pedersen_hash([root, secret, proposalId]);

//     std::println("Merkle Tree:");
//     std::println([root]);
//     std::println([left_branch, right_branch]);
//     std::println([commitment_0, commitment_1, commitment_2, commitment_3]);

//     assert(nullifier == expected_nullifier);
// }

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

// #[test]
// fn test_build_merkle_tree() {
//     let secret = 9;
//     let commitment_0 = std::hash::pedersen_hash([0, secret]);
//     let commitment_1 = std::hash::pedersen_hash([1, secret]);
//     let commitment_2 = std::hash::pedersen_hash([2, secret]);
//     let commitment_3 = std::hash::pedersen_hash([3, secret]);

//     let left_branch = std::hash::pedersen_hash([commitment_0, commitment_1]);
//     let right_branch = std::hash::pedersen_hash([commitment_2, commitment_3]);

//     let root = std::hash::pedersen_hash([left_branch, right_branch]);

//     std::println("Merkle Tree:");
//     std::println([root]);
//     std::println([left_branch, right_branch]);
//     std::println([commitment_0, commitment_1, commitment_2, commitment_3]);
// }

// #[test]
// fn test_sparse_merkle_tree() {
//     // Create hash functions for the tree
//     let hash3 = |x: [Field; 3]| -> Field { hash(x, 3) };
//     let hash2 = |x: [Field; 2]| -> Field { hash(x, 2) };

//     // Initialize the tree
//     let mut tree = SparseMerkleTree::new(hash3, hash2);

//     // Create a leaf entry (commitment pair)
//     let secret = 1;
//     let value = 100;
//     let entry = (secret, value);

//     // Create proposal ID and hash path
//     let proposal_id = 1;
//     let hash_path = [secret, value];

//     // Create siblings for the proof
//     let mut siblings = [0; 254];

//     // Calculate note commitment and root
//     let note_commitment = std::hash::pedersen_hash([secret]);
//     let root = std::merkle::compute_merkle_root(note_commitment, 0, hash_path);

//     // Calculate nullifier as per main function
//     let nullifier = std::hash::pedersen_hash([root, secret, proposal_id]);

//     // Test the main function with the same parameters as used in the original test
//     let result = main(
//         root, // root
//         0, // index
//         hash_path,
//         secret,
//         proposal_id,
//         1, // vote
//         proposal_id,
//         nullifier,
//         hash_path, // leaf
//         siblings,
//     );

//     // The expected nullifier should match what we calculated
//     assert(result == nullifier);
// }
