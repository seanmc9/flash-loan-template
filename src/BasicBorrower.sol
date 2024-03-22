// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@erc7399/IERC7399.sol";
import "./interfaces/IWETH9.sol";

import { IERC20Metadata as IERC20 } from "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import { SafeERC20 } from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

/// @dev Basic flash loan borrower. It allows to examine the state of the borrower during the callback.
/// credit: https://github.com/alcueca/erc7399-wrappers/blob/main/test/MockBorrower.sol
contract BasicBorrower {
    using SafeERC20 for IERC20;

    bytes32 public constant ERC3156PP_CALLBACK_SUCCESS = keccak256("ERC3156PP_CALLBACK_SUCCESS");
    
    IWETH9 immutable public WETH_CONTRACT;
    IERC7399 public immutable LENDER;
    address public immutable ASSET;
    uint256 public immutable AMOUNT;

    constructor(IWETH9 weth_contract_, IERC7399 lender_, address asset_, uint256 amount_) {
        WETH_CONTRACT = weth_contract_;
        LENDER = lender_;
        ASSET = asset_;
        AMOUNT = amount_;

        WETH_CONTRACT.deposit{ value: msg.sender }();
        flashBorrow();
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
        require(msg.sender == address(LENDER), "BasicBorrower: Untrusted lender");
        require(initiator == address(this), "BasicBorrower: External loan initiator");

        /// BUSINESS LOGIC HERE

        IERC20(asset).safeTransfer(paymentReceiver, amount + fee);

        return abi.encode(ERC3156PP_CALLBACK_SUCCESS);
    }

    function flashBorrow() private returns (bytes memory) {
        return LENDER.flash(address(this), ASSET, AMOUNT, "", this.onFlashLoan);
    }
}