// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/// @title IERC20.
/// @author Michealking (@BuildsWithKing).
/// @notice Created on the 31st of Oct, 2025.
/// @custom:securitycontact buildswithking@gmail.com
/// @dev ERC-20 standard interface as defined in EIP-20: https://eips.ethereum.org/EIPS/eip-20
/// @notice ERC-20 interface defining the standard token functions and events.

interface IERC20 {
    // ------------------------------------------------ Events ----------------------------------------------------------
    /// @notice Emitted once token is transferred.
    /// @param from The sender's address.
    /// @param to The receiver's address.
    /// @param value The amount of token transferred.
    event Transfer(address indexed from, address indexed to, uint256 value);

    /// @notice Emitted once a user approves a spender to spend a specific amount of token.
    /// @param owner The token owner's address.
    /// @param spender The token spender's address.
    /// @param value The amount of token approved by the owner.
    event Approval(address indexed owner, address indexed spender, uint256 value);

    // ----------------------------------------------- External Read Functions ---------------------------------------------------
    /// @notice Returns the token's existing or total supply.
    /// @return The token's existing or total supply.
    function totalSupply() external view returns (uint256);

    /// @notice Returns the address token balance.
    /// @param account The user's address.
    function balanceOf(address account) external view returns (uint256);

    /// @notice Returns the spender's allowance.
    /**
     * @dev Allowance is the amount of token approved by a token owner to a spender.
     *     It allows the spender to spend the specific amount of token onbehalf of the owner.
     */
    /// @param owner The token owner's address.
    /// @param spender The token spender's address.
    /// @return The spender's allowance approved by the token's owner.
    function allowance(address owner, address spender) external view returns (uint256);

    // ----------------------------------------------- External Write Functions ---------------------------------------------------
    /// @notice Transfers token from the caller to a user.
    /// @param to The receiver's address.
    /// @param amount The amount of token to be transferred.
    /// @return true if the transfer succeeds.
    function transfer(address to, uint256 amount) external returns (bool);

    /// @notice Approves the spender to spend the specific amount onbehalf of the user.
    /// @param spender The spender's address.
    /// @param amount The amount of token to be spent by the spender.
    /// @return true if the approval succeeds.
    function approve(address spender, uint256 amount) external returns (bool);

    /// @notice Transfers allowance from the user's balance to the spender's balance.
    /// @param from The user's address.
    /// @param to The spender's address.
    /// @param amount The amount of token to be spent by the spender.
    /// @return true if the transfer succeeds.
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}
