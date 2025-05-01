use dep::std;
use std::hash::poseidon2::Poseidon2::hash;

pub fn hasher(leaves: [Field; 2]) -> Field {
    hash(leaves, 2)
}

pub fn leaf_hasher(leaves: [Field; 3]) -> Field {
    hash(leaves, 3)
}
