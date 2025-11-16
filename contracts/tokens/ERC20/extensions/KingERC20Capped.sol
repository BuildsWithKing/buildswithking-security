// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/// @title KingERC20Capped.
/// @author Michealking (@BuildsWithKing).
/// @notice Created on the 2nd of Nov, 2025.
/// @custom:securitycontact buildswithking@gmail.com

/// @notice Imports base KingERC20 contract.
import {KingERC20} from ".././KingERC20.sol";

abstract contract KingERC20Capped is KingERC20 {
    // -------------------------------------------------- State Variables --------------------------------------------------
    /// @notice Records the token's capped supply.
    uint256 private immutable s_cap;

    // ------------------------------------------------- Constructor ----------------------------------------------------
    /// @notice Assigns the token's capped at deployment.
    /// @dev Sets the token's capped supply at deployment.
    /// @param cap_ The token's capped supply.
    constructor(uint256 cap_) {
        // Revert if the cap_ input is zero.
        if (cap_ == 0) {
            revert ZeroCap();
        }

        // Assign cap.
        s_cap = cap_;
    }

    // -------------------------------------- King or Minter's Internal Write Function --------------------------------
    /// @notice Mints tokens to an address. Should be callable only by the king or the minter.
    /// @dev Create an external function to access or Import KingERC20Mintable.
    /// @param to The receiver's address.
    /// @param amount The amount of token to be minted.
    function _mint(address to, uint256 amount) internal virtual override {
        // Revert if total supply and amount is greater than cap.
        if (s_totalSupply + amount > s_cap) {
            revert CapExceeded();
        }

        // Mint token to the receiver's address.
        super._mint(to, amount);
    }

    // -----------------------------------------------  King or Minter's External Write Function ----------------------
    /// @notice Mints tokens to an address. Should be callable only by the king or the minter.
    /// @param to The receiver's address.
    /// @param amount The amount of token to be minted.
    function mint(address to, uint256 amount) external {
        // Call the internal `_mint` function.
        _mint(to, amount);
    }

    // ----------------------------------------------- External Read Functions ----------------------------------------
    /// @notice Returns the token's capped supply.
    /// @return The token's capped supply.
    function cap() external view virtual returns (uint256) {
        return s_cap;
    }
}
