// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/// @title KingCheckAddressLib.
/// @author Michealking (@BuildsWithKing).
/// @notice Created on the 4th of Nov, 2025.
/// @custom:securitycontact buildswithking@gmail.com
/// @dev Utility library providing zero-address validation for secure address checks.

library KingCheckAddressLib {
    // -------------------------------------------------- Custom Errors ---------------------------------------------
    /// @notice Thrown for zero address input.
    /// @dev Thrown when the contract deployer or a user inputs the zero address.
    /// @param invalid_ The invalid address.
    error InvalidAddress(address invalid_);

    // -------------------------------------------------- Internal Helper Function ----------------------------------
    /// @notice Checks for zero address.
    /// @param account The address to be checked.
    function ensureNonZero(address account) internal pure {
        // Revert if account is the zero address.
        if (account == address(0)) {
            revert InvalidAddress(account);
        }
    }
}
