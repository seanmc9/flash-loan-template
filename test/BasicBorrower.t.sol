// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@forge-std/Test.sol";
import "@erc7399/IERC7399.sol";
import "../src/BasicBorrower.sol";
import "../src/interfaces/IWETH9.sol";

contract BasicBorrowerTest is Test {
    BasicBorrower public basicBorrower;

    function setUp() public {
        basicBorrower = new BasicBorrower(
            0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270,
            0x9D4D2C08b29A2Db1c614483cd8971734BFDCC9F2,
            0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270,
            10000
        );
    }

    function testContestStart() public view {
    }
}
