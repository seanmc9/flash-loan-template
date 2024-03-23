// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@forge-std/Test.sol";
import "@erc7399/IERC7399.sol";
import "../src/BasicBorrower.sol";
import "../src/interfaces/IWETH9.sol";

contract BasicBorrowerTest is Test {
    IWETH9 public constant WETH_CONTRACT = IWETH9(payable(0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270));
    IERC7399 public constant LENDER = IERC7399(0x9D4D2C08b29A2Db1c614483cd8971734BFDCC9F2);
    address public constant WETH_CONTRACT_ADDRESS = 0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270;
    uint256 public constant LOAN_AMOUNT = 10000;

    BasicBorrower public basicBorrower;

    function setUp() public {
        vm.createSelectFork({urlOrAlias: "https://rpc.ankr.com/polygon", blockNumber: 54_967_414});

        basicBorrower = new BasicBorrower{salt: bytes32("83"), value: 5}(WETH_CONTRACT, LENDER); // salt added because the default address it was deployed to already had a balance at this forked block
    }

    function testBasicBorrower() public {
        basicBorrower.flashBorrow(
            WETH_CONTRACT_ADDRESS, // WETH, WMATIC on Polygon
            LOAN_AMOUNT
        );
    }
}
