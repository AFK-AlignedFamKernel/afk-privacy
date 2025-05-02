/// Interface representing `Poll`.
#[starknet::interface]
pub trait IPollVote<TContractState> {
    fn create_poll(ref self: TContractState, amount: felt252);
    fn cast_vote(ref self: TContractState, poll_id: u64, nullifier_hash: felt252);
    fn rewards_pool(ref self: TContractState,poll_id: u64, amount: u256);
}

/// Simple contract for poll voting.
#[starknet::contract]
mod PollVote {
    use starknet::storage::StoragePathEntry;
use starknet::get_block_timestamp;
use starknet::ContractAddress;
use starknet::storage::{ Vec, StoragePointerReadAccess, StoragePointerWriteAccess, Map, StorageMapReadAccess, StorageMapWriteAccess};

    #[derive(Clone, starknet::Store, Drop)]
    pub struct PollState {
        index: u64,
        end_time: u64,
    }

    #[derive( Clone, starknet::Store, Drop)]
    pub struct OptionState {
        option_id: u64,
        option_name: ByteArray,
        option_description: ByteArray,
        option_votes: u64,
    }

    #[derive(Copy, Clone, starknet::Store, Drop)]
    pub struct PollVoteState {
        is_yes: bool,
        is_no: bool,
        is_abstain: bool,
        specific_option:u64,
    }

    #[storage]
    struct Storage {

        public_token_address:ContractAddress, // Rewards pool token
        private_token_address:ContractAddress, // ERC20 using Noir for private TX
        total_polls: u64,
        poll_per_index:Map<u64, PollState>,
        options_per_poll:Map<u64, Map<u64, OptionState>>,
        poll_per_index_vote:Map<u64, PollVoteState>,
        proposal_id: felt252,
        nullifier_default: felt252,
        root_hash: felt252,
        nullifier_hash: Map<felt252, bool>,
    }

    #[abi(embed_v0)]
    impl PollVoteImpl of super::IPollVote<ContractState> {

        fn create_poll(ref self: ContractState, amount: felt252) {
            self.proposal_id.write(amount);
        }

        fn cast_vote(ref self: ContractState, poll_id: u64, nullifier_hash: felt252) {

            let is_nullifier_used = self.nullifier_hash.read(nullifier_hash);
            assert!(is_nullifier_used, "Nullifier hash already used");
            self.nullifier_hash.write(nullifier_hash, true);

            let mut poll_state = self.poll_per_index.entry(poll_id).read();

            let timestamp = get_block_timestamp();
            assert!(poll_state.end_time > timestamp, "Poll has ended");

            // verify proof
        }

        fn rewards_pool(ref self: ContractState, poll_id: u64, amount: u256) {
        }

    
    }
}
