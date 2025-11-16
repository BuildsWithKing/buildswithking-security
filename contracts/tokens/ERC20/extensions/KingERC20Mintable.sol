// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/// @title KingERC20Mintable.
/// @author Michealking (@BuildsWithKing).
/// @notice Created on the 2nd of Nov, 2025.
/// @custom:securitycontact buildswithking@gmail.com
/// @dev Extension of KingERC20 that allows minting by authorized minters.

/// @notice Imports base KingERC20 and KingAccessControlLite contract.
import {KingERC20} from "../KingERC20.sol";
import {KingAccessControlLite} from "../../../access/core/KingAccessControlLite.sol";

abstract contract KingERC20Mintable is KingAccessControlLite, KingERC20 {
    // ------------------------------------------------- State Variable --------------------------------------------------
    /// @notice Records the minter's role.
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    /// @notice Records the minter's address.
    address public s_minter;

    // -------------------------------------------------- Events -----------------------------------------------------------
    /// @notice Emitted once the king assigns a minter.
    /// @param king The king's address.
    /// @param minter The minter's address.
    event MinterAssigned(address king, address minter);

    /// @notice Emitted once the king removes the minter's role.
    /// @param king The king's address.
    /// @param oldMinter The old minter's address.
    event MinterRemoved(address king, address oldMinter);

    // ----------------------------------------------- King's Write Functions ----------------------------------------------
    /// @notice Assigns the minter.
    /// @param minter The minter's address to be assigned.
    function assignMinter(address minter) external virtual onlyKing {
        // Assign minter.
        s_minter = minter;

        // Call the internal `_grantRole` function.
        _grantRole(MINTER_ROLE, minter);

        // Emit the event MinterAssigned.
        emit MinterAssigned(msg.sender, minter);
    }

    /// @notice Removes the minter. Callable only by the king.
    /// @param minter The minter's address to be removed.
    function removeMinter(address minter) external virtual onlyKing {
        // Call the internal `revokeRole` function.
        _revokeRole(MINTER_ROLE, minter);

        // Assign the zero address as the new minter.
        s_minter = address(0);

        // Emit the event MinterRemoved.
        emit MinterRemoved(msg.sender, minter);
    }

    // --------------------------------------- King and Minter's External Write Function ----------------------------------
    /// @notice Mints tokens to an address. Callable only by the king and the minter.
    /// @param to The receiver's address.
    /// @param amount The amount of token to be minted.
    function mint(address to, uint256 amount) external virtual onlyRole(MINTER_ROLE) {
        // Call the internal `_mint` function.
        _mint(to, amount);
    }
}
