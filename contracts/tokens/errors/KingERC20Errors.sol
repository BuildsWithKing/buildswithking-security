// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/// @title KingERC20Errors.
/// @author Michealking (@BuildsWithKing).
/// @notice Created on the 3rd of Nov, 2025.
/// @custom:securitycontact buildswithking@gmail.com

abstract contract KingERC20Errors {
    // -------------------------------------------------- Custom Errors --------------------------------------------------
    /// @notice Thrown for zero address input.
    /// @dev Thrown when the deployer or sender inputs the zero address.
    /// @param addr The zero address.
    error ZeroAddress(address addr);

    /// @notice Thrown for zero initial supply input.
    /// @dev Thrown when the deployer inputs zero as the token's initial supply.
    error ZeroInitialSupply();

    /// @notice Thrown for insufficient balance.
    /// @dev Thrown when the sender's balance is less than the transfer amount.
    /// @param balance The sender's balance.
    error InsufficientBalance(uint256 balance);

    /// @notice Thrown for insufficient allowance.
    /// @dev Thrown when the spender's allowance is less than the transfer amount.
    /// @param allowance The spender's allowance.
    error InsufficientAllowance(uint256 allowance);

    /// @notice Thrown for zero capped supply input.
    /// @dev Thrown when the deployer inputs zero as the token's capped supply.
    error ZeroCap();

    /// @notice Thrown for high input greater than token's capped supply.
    /// @dev Thrown when the king or minter inputs an amount greater than the capped supply.
    error CapExceeded();

    /// @notice Thrown for unauthorized access.
    /// @dev Thrown when a user tries performing the king and burner's only operation.
    error NotAuthorized();
}
