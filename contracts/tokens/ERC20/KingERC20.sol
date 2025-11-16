// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/// @title KingERC20.
/// @author Michealking (@BuildsWithKing).
/// @notice Created on the 31st of Oct, 2025.
/// @custom:securitycontact buildswithking@gmail.com
/**
 * @notice This contract defines the base ERC20 logic.
 * It manages token transfers, approvals, minting, and burning. Following the ERC20 standard.
 */

/// @notice Imports IERC20Metadata interface, KingERC20Errors contract and KingCheckAddressLib Library.
import {IERC20Metadata} from "./interfaces/IERC20Metadata.sol";
import {KingERC20Errors} from "../errors/KingERC20Errors.sol";
import {KingCheckAddressLib} from "../../access/utils/KingCheckAddressLib.sol";

abstract contract KingERC20 is KingERC20Errors, IERC20Metadata {
    // -------------------------------------------------- State Variables --------------------------------------------------
    /// @notice Records the king's address.
    address public s_king;

    /// @notice Records the token's name.
    string private s_name;

    /// @notice Records the token's symbol.
    string private s_symbol;

    /// @notice Records the token's total supply.
    uint256 internal s_totalSupply;

    // ------------------------------------------------ Mappings --------------------------------------------------------
    /// @notice Maps a user's address to their respective balance.
    mapping(address => uint256) private s_balances;

    /// @notice Maps a user's address to their spender's address and allowance.
    /**
     * @dev Allowance is the amount of token approved by a token owner to a spender.
     *     It allows the spender to spend the specific amount of token on behalf of the owner.
     */
    mapping(address => mapping(address => uint256)) private s_allowances;

    // ------------------------------------------------ Events -----------------------------------------------------------
    /// @notice Emitted once token is burned. Ceased from existing.
    /// @param from The sender's address.
    /// @param amount The amount of token burned.
    event Burned(address indexed from, uint256 amount);

    /// @notice Emitted once token is minted.
    /// @param minter The minter's address.
    /// @param to The receiver's address.
    /// @param amount The amount of token minted.
    event Minted(address indexed minter, address indexed to, uint256 amount);

    // ------------------------------------------------- Constructor ----------------------------------------------------
    /// @notice Assigns the king, and token's information at deployment.
    /// @dev Sets the king, token's name, symbol, initial supply at deployment. Mints the initial supply to the king upon deployment.
    /// @param king_ The king's address.
    /// @param name_ The token's name.
    /// @param symbol_ The token's symbol.
    /// @param initialSupply_ The token's initial supply.
    constructor(address king_, string memory name_, string memory symbol_, uint256 initialSupply_) {
        // Call the internal Library `ensureNonZero` function.
        KingCheckAddressLib.ensureNonZero(king_);

        // Revert if the initialSupply_ input is zero.
        if (initialSupply_ == 0) {
            revert ZeroInitialSupply();
        }

        // Assign the king.
        s_king = king_;

        // Assign the token's name.
        s_name = name_;

        // Assign the token's symbol.
        s_symbol = symbol_;

        // Assign the token's total supply.
        s_totalSupply = initialSupply_;

        // Assign the initial supply to the king's balance.
        s_balances[king_] = initialSupply_;

        // Emit the event Minted.
        emit Minted(address(0), king_, initialSupply_);

        // Emit the event Transfer.
        emit Transfer(address(0), king_, initialSupply_);
    }

    // --------------------------------------------------- Internal Write Functions ---------------------------------------
    /// @notice Transfers token from one user to another.
    /// @param from The sender's address.
    /// @param to The receiver's address.
    /// @param amount The amount of token to be transferred.
    function _transfer(address from, address to, uint256 amount) internal {
        // Call the internal Library `ensureNonZero` function.
        KingCheckAddressLib.ensureNonZero(from);
        KingCheckAddressLib.ensureNonZero(to);

        // Read the sender's balance.
        uint256 fromBalance = s_balances[from];

        // Revert if the transfer amount is greater than the sender's balance.
        if (amount > fromBalance) {
            revert InsufficientBalance(fromBalance);
        }

        // Subtract the amount from the sender's balance and Add to the receiver's balance.
        unchecked {
            s_balances[from] = fromBalance - amount;
            s_balances[to] += amount;
        }

        // Emit the event Transfer.
        emit Transfer(from, to, amount);
    }

    /// @notice Approves the spender to spend the specific amount on behalf of the owner.
    /// @param owner The owner's address.
    /// @param spender The spender's address.
    /// @param amount The amount of token to be spent by the spender.
    function _approve(address owner, address spender, uint256 amount) internal {
        // Call the internal Library `ensureNonZero` function.
        KingCheckAddressLib.ensureNonZero(owner);
        KingCheckAddressLib.ensureNonZero(spender);

        // Permit the spender to spend this amount on behalf of the owner.
        s_allowances[owner][spender] = amount;

        // Emit the event Approval.
        emit Approval(owner, spender, amount);
    }

    // --------------------------------------------------- External Write Functions ------------------------------------
    /// @notice Transfers token from the caller to a user.
    /// @param to The receiver's address.
    /// @param amount The amount of token to be transferred.
    /// @return True if the transfer succeeds.
    function transfer(address to, uint256 amount) external virtual returns (bool) {
        // Call the internal `_transfer` function.
        _transfer(msg.sender, to, amount);

        return true;
    }

    /// @notice Approves the spender to spend the specific amount on behalf of the caller.
    /// @param spender The spender's address.
    /// @param amount The amount of token to be spent by the spender.
    /// @return True if the approval succeeds.
    function approve(address spender, uint256 amount) external virtual returns (bool) {
        // Call the internal `_approve` function.
        _approve(msg.sender, spender, amount);

        return true;
    }

    /// @notice Transfers allowance from the user's balance to the spender's balance.
    /// @param from The user's address.
    /// @param to The spender's address.
    /// @param amount The amount of token to be spent by the spender.
    /// @return True if the transfer succeeds.
    function transferFrom(address from, address to, uint256 amount) external virtual returns (bool) {
        // Read the spender's allowance.
        uint256 fromAllowance = s_allowances[from][msg.sender];

        // Revert if the amount is greater than the spender's allowance.
        if (amount > fromAllowance) {
            revert InsufficientAllowance(fromAllowance);
        }

        // Check if the spender's allowance is not unlimited.
        if (fromAllowance != type(uint256).max) {
            // Subtract the amount from the spender's allowance.
            unchecked {
                s_allowances[from][msg.sender] = fromAllowance - amount;
            }
        }

        // Call the internal `_transfer` function.
        _transfer(from, to, amount);

        return true;
    }

    // ----------------------------------------------- External Read Functions ----------------------------------------
    /// @notice Returns the token's existing or total supply.
    /// @return The token's existing or total supply.
    function totalSupply() external view virtual returns (uint256) {
        return s_totalSupply;
    }

    /// @notice Returns the token's name.
    /// @return The token's name.
    function name() external view virtual returns (string memory) {
        return s_name;
    }

    /// @notice Returns the token's symbol.
    /// @return The token's symbol.
    function symbol() external view virtual returns (string memory) {
        return s_symbol;
    }

    /// @notice Returns the token's decimal.
    /// @dev Returns 18 the default decimal for ETH tokens.
    /// @return The token's decimal.
    function decimals() external view virtual returns (uint8) {
        return 18;
    }

    /// @notice Returns the address token balance.
    /// @param account The user's address.
    function balanceOf(address account) external view virtual returns (uint256) {
        return s_balances[account];
    }

    /// @notice Returns the spender's allowance.
    /**
     * @dev Allowance is the amount of token approved by a token owner to a spender.
     *     It allows the spender to spend the specific amount of token on behalf of the owner.
     */
    /// @param owner The token owner's address.
    /// @param spender The token spender's address.
    /// @return The spender's allowance approved by the token's owner.
    function allowance(address owner, address spender) external view virtual returns (uint256) {
        return s_allowances[owner][spender];
    }

    // -------------------------------------- King or Minter's Internal Function ---------------------------------
    /// @notice Mints tokens to an address. Should be callable only by the king or the minter.
    /// @dev Create an external function to access or Import KingERC20Mintable.
    /// @param to The receiver's address.
    /// @param amount The amount of tokens to be minted.
    function _mint(address to, uint256 amount) internal virtual {
        // Call the internal Library `ensureNonZero` function.
        KingCheckAddressLib.ensureNonZero(to);

        // Add the amount to the token's total supply and to the receiver's balance.
        unchecked {
            s_totalSupply += amount;
            s_balances[to] += amount;
        }

        // Emit the event Transfer.
        emit Transfer(address(0), to, amount);

        // Emit the event Minted.
        emit Minted(msg.sender, to, amount);
    }

    /// @notice Burns token. i.e Removes certain amount of the token from existence.
    /// @dev Create an external function to access or Import KingERC20Burnable.
    /// @param from The sender's address.
    /// @param amount The amount of tokens to be burned.
    function _burn(address from, uint256 amount) internal virtual {
        // Call the internal Library `ensureNonZero` function.
        KingCheckAddressLib.ensureNonZero(from);

        // Read the sender's balance.
        uint256 fromBalance = s_balances[from];

        // Revert if the amount to be burned is greater than the sender's balance.
        if (amount > fromBalance) {
            revert InsufficientBalance(fromBalance);
        }

        // Subtract the amount from the sender's balance and from the token's total supply.
        unchecked {
            s_balances[from] = fromBalance - amount;
            s_totalSupply -= amount;
        }

        // Emit the event Transfer.
        emit Transfer(from, address(0), amount);

        // Emit the event Burned.
        emit Burned(from, amount);
    }
}
