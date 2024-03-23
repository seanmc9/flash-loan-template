## Flash Loan Template

`forge create BasicBorrower --constructor-args <LENDER_ADDRESS> <WETH_ADDRESS> --rpc-url <RPC_URL> --private-key <PRIVATE_KEY>`

`cast send <BASIC_BORROWER_ADDRESS> "flashBorrow(address,uint256)(bytes)" <LOAN_ASSET_ADDRESS> <LOAN_AMOUNT>  --value <AMOUNT_OF_ETH_NEEDED_FOR_COSTS> --rpc-url <RPC_URL> --private-key <PRIVATE_KEY>`

- Lender addresses [here](https://github.com/alcueca/erc7399-wrappers/tree/main)
- RPC URLs [here](https://github.com/jk-labs-inc/jokerace/tree/staging/packages/react-app-revamp/config/wagmi/custom-chains)
