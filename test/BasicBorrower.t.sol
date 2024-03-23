// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@forge-std/Test.sol";
import "@erc7399/IERC7399.sol";
import "../src/BasicBorrower.sol";
import "../src/interfaces/IWETH9.sol";

contract BasicBorrowerTest is Test {
    IWETH9 public constant WETH_CONTRACT = IWETH9(payable(0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270));
    IERC7399 public constant LENDER = IERC7399(0x9D4D2C08b29A2Db1c614483cd8971734BFDCC9F2);

    BasicBorrower public basicBorrower;

    function setUp() public {
        vm.createSelectFork({urlOrAlias: "https://rpc.ankr.com/polygon", blockNumber: 54_967_414});

        basicBorrower = new BasicBorrower(WETH_CONTRACT, LENDER);
    }

    function testBasicBorrower() public {
        vm.deal(address(basicBorrower), 5);
        basicBorrower.flashBorrow(
            0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270, // WETH, WMATIC on Polygon
            10000
        );
    }
}
