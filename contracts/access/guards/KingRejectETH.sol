// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/// @title KingRejectETH.
/// @author Michealking (@BuildsWithKing).
/// @custom:securitycontact buildswithking@gmail.com
/// @notice Created on the 7th of Oct, 2025.
/// @dev Abstract contract to be inherited by contracts that must reject any direct ETH transfers.

abstract contract KingRejectETH {
    // ---------------------------------------------------- Custom Error ------------------------------
    /// @notice Thrown when ETH is sent directly to the contract.
    /// @dev Thrown when a user or contract transfers ETH.
    error EthRejected();

    // --------------------------------------------------- Receive & Fallback Function -----------------
    /// @notice Rejects ETH transfers with empty calldata.
    receive() external payable {
        revert EthRejected();
    }

    /// @notice Rejects ETH transfers with non-empty calldata.
    fallback() external payable {
        revert EthRejected();
    }
}
