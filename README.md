# Foundry and Aave Interactions

Test and interact with Aave using Foundry and a Sepolia fork.

### Installation

```bash
git clone https://github.com/ManaanAnsari/aave-foundry-interactions.git
cd aave-foundry-interactions
```

### Setting Up

Open a new terminal and run the mainnet fork. Make sure you create a `.env` file from the provided template.

```bash
source .env
anvil --fork-url $SEPOLIA_RPC_URL
```

### Building the Project

Run the build command to ensure everything is set up correctly.

```bash
forge build
```

### Running Tests

Run all tests:

```bash
forge test --rpc-url 127.0.0.1:8545 -vvv
```

Run individual tests:

```bash
forge test --mt testSupplyAsset --rpc-url 127.0.0.1:8545 -vvv
```

### Functionalities Tested

- [x] Deposit
- [x] Borrow
- [x] Repay
- [x] Withdraw
- [ ] Liquidations
- [ ] Flashloans
