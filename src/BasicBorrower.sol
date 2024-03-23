// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@erc7399/IERC7399.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./interfaces/IWETH9.sol";

import {IERC20Metadata as IERC20} from "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

/// @dev Basic flash loan borrower. It allows to examine the state of the borrower during the callback.
/// credit: https://github.com/alcueca/erc7399-wrappers/blob/main/test/MockBorrower.sol
contract BasicBorrower is Ownable {
    using SafeERC20 for IERC20;

    bytes32 public constant ERC3156PP_CALLBACK_SUCCESS = keccak256("ERC3156PP_CALLBACK_SUCCESS");

    IWETH9 public immutable wethContract;
    IERC7399 public lender;

    constructor(IWETH9 wethContract_, IERC7399 lender_) {
        wethContract = wethContract_;
        setLender(lender_);
    }

    function setLender(IERC7399 lender_) public {
        lender = lender_;
    }

    function retrieveNativeAsset() public onlyOwner {
        Address.sendValue(payable(msg.sender), address(this).balance);
    }

    function retrieveERC20(address asset) public onlyOwner {
        IERC20(asset).safeTransfer(msg.sender, IERC20(asset).balanceOf(address(this)));
    }

    /// @dev Flash loan callback
    function onFlashLoan(
        address initiator,
        address paymentReceiver,
        address asset,
        uint256 amount,
        uint256 fee,
        bytes calldata
    ) external returns (bytes memory) {
        require(msg.sender == address(lender), "BasicBorrower: Untrusted lender");
        require(initiator == address(this), "BasicBorrower: External loan initiator");

        /// BUSINESS LOGIC HERE
        wethContract.deposit{value: address(this).balance}();

        IERC20(asset).safeTransfer(paymentReceiver, amount + fee);

        return abi.encode(ERC3156PP_CALLBACK_SUCCESS);
    }

    function flashBorrow(address asset, uint256 amount) public payable onlyOwner returns (bytes memory) {
        return lender.flash(address(this), asset, amount, "", this.onFlashLoan);
    }
}
