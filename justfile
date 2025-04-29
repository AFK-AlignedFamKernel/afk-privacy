
RPC_URL := "https://starknet-sepolia.public.blastapi.io/rpc/v0_7"
CIRCUIT_ROOT := "circuits"
CONTRACTS_ROOT := "contracts"
UI_ROOT := "ui"
API_ROOT := "api"

# ui

ui-run:
    (cd {{UI_ROOT}} && npm run dev)

# api

api-run:
    (cd {{API_ROOT}} && docker-compose up)

# circuits transfer

circuits-test circuit:
    (cd {{CIRCUIT_ROOT}}/{{circuit}} && nargo test --show-output)

circuits-check circuit:
    (cd {{CIRCUIT_ROOT}}/{{circuit}} && nargo check)

circuits-build circuit:
    (cd {{CIRCUIT_ROOT}}/{{circuit}} && nargo build)

circuits-fmt circuit:
    (cd {{CIRCUIT_ROOT}}/{{circuit}} && nargo fmt)


circuits-witness circuit:
    (cd {{CIRCUIT_ROOT}}/{{circuit}} &&  nargo execute witness && bb write_vk --scheme ultra_honk --oracle_hash keccak -b ./target/{{circuit}}.json -o ./target/)


circuits-proof circuit:
    (cd {{CIRCUIT_ROOT}}/{{circuit}} && nargo execute witness && bb prove_ultra_keccak_honk -b target/{{circuit}}.json -w target/witness.gz -o target/proof.bin && garaga calldata --system ultra_keccak_honk --vk target/vk.bin --proof target/proof.bin --format array > calldata.txt)


circuits-build-nargo circuit:
    (cd {{CIRCUIT_ROOT}}/{{circuit}} && nargo execute witness && bb write_vk --scheme ultra_honk -b --oracle_hash keccak ./target/{{circuit}}.json -o ./target/)


circuits-proof-nargo circuit:
    (cd {{CIRCUIT_ROOT}}/{{circuit}} && mkdir -p target/proof && bb prove --scheme ultra_honk --bytecode_path target/{{circuit}}.json --witness_path target/witness.gz --output_path target/proof --oracle_hash keccak)
    # (cd {{CIRCUIT_ROOT}}/{{circuit}} && bb write_vk --scheme ultra_honk --oracle_hash keccak -b ./target/{{circuit}}.json -o ./target/ && mkdir -p target/proof && bb prove --scheme ultra_honk --bytecode_path target/{{circuit}}.json --witness_path target/witness.gz --output_path target/proof --oracle_hash keccak)
    # (cd {{CIRCUIT_ROOT}}/{{circuit}} && bb write_vk --scheme ultra_honk --oracle_hash keccak -b ./target/zk_vote.json -o ./target/ && bb prove_ultra_keccak_honk -b target/{{circuit}}.json -w target/witness.gz -o target/proof.bin )
    # (cd {{CIRCUIT_ROOT}}/{{circuit}} && nargo execute witness && bb prove_ultra_keccak_honk -b target/{{circuit}}.json -w target/witness.gz -o target/proof.bin)


circuits-verify circuit:
    (cd {{CIRCUIT_ROOT}}/{{circuit}} && bb verify --scheme ultra_honk --proof_path target/proof/proof --vk_path target/vk --oracle_hash keccak)
    # (cd {{CIRCUIT_ROOT}}/{{circuit}} && bb write_vk --scheme ultra_honk --oracle_hash keccak -b ./target/zk_vote.json -o ./target/ && bb prove_ultra_keccak_honk -b target/{{circuit}}.json -w target/witness.gz -o target/proof.bin )
    # (cd {{CIRCUIT_ROOT}}/{{circuit}} && nargo execute witness && bb prove_ultra_keccak_honk -b target/{{circuit}}.json -w target/witness.gz -o target/proof.bin)




circuits-generate-verifier circuit path: 
    (cd {{CIRCUIT_ROOT}}/{{circuit}} && nargo build)
    # (cd {{CIRCUIT_ROOT}}/{{circuit}} && bb write_vk -b ./target/{{path}}.json -o ./target/ && cp ./target/vk ./target/vk.bin)
    (cd {{CIRCUIT_ROOT}}/{{circuit}} && bb write_vk --scheme ultra_honk --oracle_hash keccak  -b ./target/{{path}}.json -o ./target/ && cp ./target/vk ./target/vk.bin)
    (cd {{CIRCUIT_ROOT}}/{{circuit}} && garaga gen --system ultra_keccak_honk --vk target/vk --project-name contracts)
    (cd {{CIRCUIT_ROOT}}/{{circuit}} && bb write_solidity_verifier -k ./target/vk -o ./target/Verifier.sol)

circuits-declare-verifier circuit:
    (cd {{CIRCUIT_ROOT}}/{{circuit}}/contracts && sncast --account deployer declare --url {{RPC_URL}} --contract-name UltraKeccakHonkVerifier --fee-token ETH)

circuits-deploy-verifier circuit class_hash:
    (cd {{CIRCUIT_ROOT}}/{{circuit}}/contracts && sncast --account deployer deploy --url {{RPC_URL}} --class-hash {{class_hash}} --fee-token ETH)

devnet:
	starknet-devnet --accounts=2 --seed=0 --initial-balance=100000000000000000000000
# contracts

contracts-test:
    (cd {{CONTRACTS_ROOT}} && snforge test)

contracts-fmt:
    (cd {{CONTRACTS_ROOT}} && scarb fmt)

contracts-declare:
    (cd {{CONTRACTS_ROOT}} && sncast --account deployer declare --url {{RPC_URL}} --contract-name Privado --fee-token ETH)

contracts-deploy class_hash:
    (cd {{CONTRACTS_ROOT}} && sncast --account deployer deploy --url {{RPC_URL}} --class-hash {{class_hash}} --fee-token ETH)

contracts-deployer-account-create:
    (cd {{CONTRACTS_ROOT}} && sncast account create -n deployer --url {{RPC_URL}})

contracts-deployer-account-deploy:
    (cd {{CONTRACTS_ROOT}} && sncast account deploy --name deployer --url {{RPC_URL}} --fee-token ETH)

