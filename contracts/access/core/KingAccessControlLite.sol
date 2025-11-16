// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/// @title KingAccessControlLite.
/// @author Michealking (@BuildsWithKing).
/// @notice Created on the 3rd of Nov, 2025.
/// @custom:securitycontact buildswithking@gmail.com
/// @dev Minimal and Gas-efficient role-based access control module for king-based contracts.

/// @notice Imports KingCheckAddressLib Library.
import {KingCheckAddressLib} from "../utils/KingCheckAddressLib.sol";

abstract contract KingAccessControlLite {
    // --------------------------------------- Custom Errors -----------------------------------------
    /// @notice Thrown for unauthorized access.
    /// @dev Thrown when a user tries to perform a restricted operation without the required role.
    /// @param caller The caller's address.
    /// @param role The current role.
    error Unauthorized(address caller, bytes32 role);

    // ----------------------------------------- Events ----------------------------------------------
    /// @notice Emitted once a role is granted to an address.
    /// @param king The king's address.
    /// @param role The role granted.
    /// @param account The address granted with the role.
    event RoleGranted(address indexed king, bytes32 indexed role, address indexed account);

    /// @notice Emitted once a role is revoked from an address.
    /// @param king The king's address.
    /// @param role The role revoked.
    /// @param account The address revoked from the role.
    event RoleRevoked(address indexed king, bytes32 indexed role, address indexed account);

    // ------------------------------------------ State Variables -------------------------------------
    /// @notice Records the king's role.
    bytes32 public constant KING_ROLE = keccak256("KING_ROLE");

    // ------------------------------------------ Mappings --------------------------------------------
    /// @notice Maps each role to the corresponding address permission.
    mapping(bytes32 => mapping(address => bool)) internal s_roles;

    // ------------------------------------------ Modifiers -------------------------------------------
    /// @notice Restricts access to addresses with the specific roles.
    /// @dev Restricts access to only the king and the address with this specific role.
    /// @param role The role required for the execution.
    modifier onlyRole(bytes32 role) {
        // Revert if the caller isn't the king or doesn't have the required role.
        if (!s_roles[KING_ROLE][msg.sender] && !s_roles[role][msg.sender]) {
            revert Unauthorized(msg.sender, role);
        }
        _;
    }

    /// @notice Restricts access to only the king.
    modifier onlyKing() {
        // Revert if the caller doesn't have the king's role.
        if (!s_roles[KING_ROLE][msg.sender]) {
            revert Unauthorized(msg.sender, KING_ROLE);
        }
        _;
    }

    // ------------------------------------------ Constructor -----------------------------------------
    /// @notice Assigns the deployer as the initial king.
    /// @dev Sets the king's role at deployment.
    /// @param king_ The king's address.
    constructor(address king_) {
        // Call the internal Library `ensureNonZero` function.
        KingCheckAddressLib.ensureNonZero(king_);

        // Assign KING_ROLE to the _king.
        unchecked {
            s_roles[KING_ROLE][king_] = true;
        }

        // Emit the event RoleGranted.
        emit RoleGranted(address(0), KING_ROLE, king_);
    }

    // ----------------------------------------- King's Internal Write Functions ---------------------
    /// @notice Grants a role to an address. Callable only by the king.
    /// @param role The role to be granted.
    /// @param account The address to be granted the role.
    function _grantRole(bytes32 role, address account) internal onlyKing {
        // Call the internal Library `ensureNonZero` function.
        KingCheckAddressLib.ensureNonZero(account);

        // Return if the address already has the role.
        if (s_roles[role][account]) {
            return;
        }

        // Assign the role to the address.
        unchecked {
            s_roles[role][account] = true;
        }

        // Emit the event RoleGranted.
        emit RoleGranted(msg.sender, role, account);
    }

    /// @notice Revokes a role from an address. Callable only by the king.
    /// @param role The role to be revoked.
    /// @param account The address to be revoked from the role.
    function _revokeRole(bytes32 role, address account) internal onlyKing {
        // Call the internal Library `ensureNonZero` function.
        KingCheckAddressLib.ensureNonZero(account);

        // Return if the address no longer has the role.
        if (!s_roles[role][account]) {
            return;
        }

        // Revoke the role from the address.
        unchecked {
            s_roles[role][account] = false;
        }

        // Emit the event RoleRevoked.
        emit RoleRevoked(msg.sender, role, account);
    }

    // ------------------------------------------- King's External Write Function ---------------------
    /// @notice Transfers the king's role. Callable only by the king.
    /// @param newKing The new king's address.
    function transferKingRole(address newKing) external onlyKing {
        // Call the internal Library `ensureNonZero` function.
        KingCheckAddressLib.ensureNonZero(newKing);

        // Return if the old king's address is the same as the new king's address.
        if (msg.sender == newKing) {
            return;
        }

        unchecked {
            // Transfer the king role to the new address.
            s_roles[KING_ROLE][newKing] = true;

            // Revoke the current king's role.
            s_roles[KING_ROLE][msg.sender] = false;
        }

        // Emit the event RoleRevoked.
        emit RoleRevoked(msg.sender, KING_ROLE, msg.sender);

        // Emit the event RoleGranted.
        emit RoleGranted(msg.sender, KING_ROLE, newKing);
    }

    // ------------------------------------------- External Write Function --------------------------
    /// @notice Renounces the caller's role.
    /// @param role The role to be renouced.
    function renounceRole(bytes32 role) external {
        // Return if the caller is the king.
        if (s_roles[KING_ROLE][msg.sender]) {
            return;
        }

        // Renounce the caller's role.
        unchecked {
            s_roles[role][msg.sender] = false;
        }

        // Emit the event RoleRevoked.
        emit RoleRevoked(msg.sender, role, msg.sender);
    }

    // ------------------------------------------- Public Read Function -----------------------------
    /// @notice Checks if an address has a specific role.
    /// @param role The role to check.
    /// @param account The address to check.
    /// @return True if the address has the role. Otherwise false.
    function hasRole(bytes32 role, address account) public view virtual returns (bool) {
        return s_roles[role][account];
    }
}
