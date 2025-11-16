// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/// @title IERC20Metadata.
/// @author Michealking (@BuildsWithKing).
/// @notice Created on the 2nd of Nov, 2025.
/// @custom:securitycontact buildswithking@gmail.com
/// @dev ERC-20 optional metadata functions as defined in EIP-20: https://eips.ethereum.org/EIPS/eip-20.

/// @notice Imports IERC20 interface.
import {IERC20} from "./IERC20.sol";

interface IERC20Metadata is IERC20 {
    // ------------------------------------------- External Read Functions ---------------------------------------
    /// @notice Returns the token's name.
    /// @return The token's name.
    function name() external view returns (string memory);

    /// @notice Returns the token's symbol.
    /// @return The token's symbol.
    function symbol() external view returns (string memory);

    /// @notice Returns the token's decimal.
    /// @return The token's decimal.
    function decimals() external view returns (uint8);
}
