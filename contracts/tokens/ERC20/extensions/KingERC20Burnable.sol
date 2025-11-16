// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/// @title KingERC20Burnable.
/// @author Michealking (@BuildsWithKing).
/// @notice Created on the 2nd of Nov, 2025.
/// @custom:securitycontact buildswithking@gmail.com
/// @dev Extension of KingERC20 that allows burning by users and authorized burners.

/// @notice Imports base KingERC20 and KingAccessControlLite contract.
import {KingERC20} from "../KingERC20.sol";
import {KingAccessControlLite} from "../../../access/core/KingAccessControlLite.sol";

abstract contract KingERC20Burnable is KingAccessControlLite, KingERC20 {
    // ------------------------------------------------- State Variables --------------------------------------------------
    /// @notice Records the burner's role.
    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");

    /// @notice Records the burner's address.
    address public s_burner;

    // -------------------------------------------------- Events -----------------------------------------------------------
    /// @notice Emitted once the king assigns a burner.
    /// @param king The king's address.
    /// @param burner The burner's address.
    event BurnerAssigned(address indexed king, address indexed burner);

    /// @notice Emitted once the king removes the burner's role.
    /// @param king The king's address.
    /// @param oldBurner The old burner's address.
    event BurnerRemoved(address indexed king, address indexed oldBurner);

    // ----------------------------------------------- King's Write Functions ----------------------------------------------
    /// @notice Assigns the burner. Callable only by the king.
    /// @param burner The burner's address to be assigned.
    function assignBurner(address burner) external virtual onlyKing {
        // Assign burner.
        s_burner = burner;

        // Call the internal `_grantRole` function.
        _grantRole(BURNER_ROLE, burner);

        // Emit the event BurnerAssigned.
        emit BurnerAssigned(msg.sender, burner);
    }

    /// @notice Removes the burner. Callable only by the king.
    /// @param burner The burner's address to be removed.
    function removeBurner(address burner) external virtual onlyKing {
        // Call the internal `revokeRole` function.
        _revokeRole(BURNER_ROLE, burner);

        // Assign the zero address as the new burner.
        s_burner = address(0);

        // Emit the event BurnerRemoved.
        emit BurnerRemoved(msg.sender, burner);
    }

    // ----------------------------------------- External Write Function ----------------------------------
    /// @notice Burns token. i.e Removes certain amount of the token from existence.
    /// @param amount The amount of tokens to be burned.
    function burn(uint256 amount) external virtual {
        // Call the internal `burn` function.
        _burn(msg.sender, amount);
    }

    // ----------------------------------------- King and Burner's External Write Function -----------------
    /// @notice Burns token. i.e Removes certain amount of the token from existence. Callable only by the king and the burner.
    /// @param from The sender's address.
    /// @param amount The amount of tokens to be burned.
    function burnFrom(address from, uint256 amount) external virtual onlyRole(BURNER_ROLE) {
        // Call the internal `burn` function.
        _burn(from, amount);
    }
}
