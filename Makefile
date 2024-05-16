-include .env

build:; forge build

test_trade:; forge test --fork-url $(MAINNET_RPC_URL) -vvv