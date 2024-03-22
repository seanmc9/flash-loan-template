// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@erc7399/IERC7399.sol";

/// @dev Basic flash loan borrower. It allows to examine the state of the borrower during the callback.
/// credit: https://github.com/alcueca/erc7399-wrappers/blob/main/test/MockBorrower.sol
contract BasicBorrower {
    using SafeERC20 for IERC20;

    bytes32 public constant ERC3156PP_CALLBACK_SUCCESS = keccak256("ERC3156PP_CALLBACK_SUCCESS");
    IERC7399 lender;

    uint256 public flashBalance;
    address public flashInitiator;
    address public flashAsset;
    uint256 public flashAmount;
    uint256 public flashFee;

    constructor(IERC7399 lender_) {
        setLender(lender_);
    }

    function setLender(IERC7399 lender_) public {
        lender = lender_;
    }

    /// @dev Flash loan callback
    function onFlashLoan(
        address initiator,
        address paymentReceiver,
        address asset,
        uint256 amount,
        uint256 fee,
        bytes calldata
    )
        external
        returns (bytes memory)
    {
        require(msg.sender == address(lender), "BasicBorrower: Untrusted lender");
        require(initiator == address(this), "BasicBorrower: External loan initiator");

        /// BUSINESS LOGIC HERE
        flashBalance = IERC20(asset).balanceOf(address(this));
        IERC20(asset).safeTransfer(paymentReceiver, amount + fee);

        return abi.encode(ERC3156PP_CALLBACK_SUCCESS);
    }

    function flashBorrow(address asset, uint256 amount) public returns (bytes memory) {
        return lender.flash(address(loanReceiver), asset, amount, "", this.onFlashLoan);
    }
}