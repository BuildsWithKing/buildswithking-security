// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/// @title KingableContracts
/// @author Michealking (@BuildsWithKing).
/// @custom:securitycontact buildswithking@gmail.com
/**
 * @notice Created on the 22nd of Sept, 2025.
 *
 *         This contract sets the king at deployment (Initial king must be a contract, EOAs are disallowed),
 *            restricts access to some functions with the modifier "onlyKing".
 *
 *         Allows the king transfer kingship to contract addresses, and renounce kingship to the zero address
 *         (which makes the contract kingless).
 *
 *   @dev  Abstract contract, to be inherited by other contracts that require contract-based access control.
 */

/// @notice Imports KingAccessControlLite contract.
import {KingAccessControlLite} from "../core/KingAccessControlLite.sol";

abstract contract KingableContracts is KingAccessControlLite {
    // ----------------------------------------------------------- Custom Errors --------------------------------------------------
    /// @notice Thrown for the same king's address.
    /// @dev Thrown when the king tries transferring kingship to self.
    /// @param _king The king's address.
    error SameKing(address _king);

    /// @notice Thrown for invalid addresses (Zero, EOAs, or this contract address).
    /// @dev Thrown when the king tries transferring kingship to an EOAs (code length = 0), zero, or this contract address.
    /// @param _invalidAddress The invalid address.
    error InvalidKing(address _invalidAddress);
    // ----------------------------------------------------------- State Variable --------------------------------------------
    /// @notice Records the king's address.
    address public s_king;

    // -------------------------------------------------------------- Events --------------------------------------------------
    /// @notice Emitted when the king transfers kingship.
    /// @param _oldKingAddress The old king's address.
    /// @param _newKingAddress The new king's address.
    event KingshipTransferred(address indexed _oldKingAddress, address indexed _newKingAddress);

    /// @notice Emitted when the king renounces kingship.
    /// @param _oldKingAddress The old king's address.
    /// @param _zeroAddress Always the zero address (indicates renouncement).
    event KingshipRenounced(address indexed _oldKingAddress, address _zeroAddress);

    // ------------------------------------------------------------- Constructor ---------------------------------------------------
    /// @notice Deploys with an initial contract-only king.
    /// @dev Reverts if `_kingAddress` is the zero, an EOA, or this contract address.
    /// @param _kingAddress The king's address.
    constructor(address _kingAddress) {
        // Revert if `_kingAddress` is the zero, an EOA, or this contract address.
        if (_kingAddress == address(0) || _kingAddress.code.length == 0 || _kingAddress == address(this)) {
            revert InvalidKing(_kingAddress);
        }

        // Assign _kingAddress as the king.
        s_king = _kingAddress;

        // Call KingAccessControlLite internal initializer function.
        __KingACL_init(_kingAddress);

        // Emit the event KingshipTransferred.
        emit KingshipTransferred(address(0), _kingAddress);
    }

    // ------------------------------------------------------------- King's Internal Write Functions -------------------------------
    /// @notice Transfers kingship to another contract.
    /// @dev Reverts if _newKingAddress is the zero, an EOA, this contract, or the same as the current king's address.
    /// @param _newKingAddress The new king's contract address.
    function _transferKingshipTo(address _newKingAddress) internal onlyKing {
        // Assign _currentKing.
        address _currentKing = s_king;

        // Revert if the new king address is the current king's address.
        if (_currentKing == _newKingAddress) {
            revert SameKing(_currentKing);
        }

        // Revert if the new king's address is the zero, this contract, or an EOA.
        if (_newKingAddress == address(0) || _newKingAddress == address(this) || _newKingAddress.code.length == 0) {
            revert InvalidKing(_newKingAddress);
        }

        // Assign _newKingAddress as the new king.
        s_king = _newKingAddress;

        // Call KingAccessControlLite `_transferKingRole` internal function. 
        _transferKingRole(_newKingAddress);

        // Emit the event KingshipTransferred.
        emit KingshipTransferred(_currentKing, _newKingAddress);
    }

    /// @notice Renounces Kingship to the zero address.
    function _renounceKingship() internal onlyKing {
        // Assign _currentKing.
        address _currentKing = s_king;

        // Call KingAccessControlLite `_transferKingRole` internal function. 
        _transferKingRole(address(0));

        // Assign zero address as the king.
        s_king = address(0);

        // Emit the event KingshipRenounced.
        emit KingshipRenounced(_currentKing, address(0));
    }

    // ------------------------------------------------------------- King's External Write Functions -------------------------------
    /// @notice Transfers kingship to another contract.
    /// @dev Reverts if _newKingAddress is the zero, any EOA, this contract, or the same as the current king's address.
    /// @param _newKingAddress The new king's contract address.
    function transferKingshipTo(address _newKingAddress) external virtual onlyKing {
        // Call the internal `_transferKingshipTo` function.
        _transferKingshipTo(_newKingAddress);
    }

    /// @notice Renounces Kingship to the zero address.
    function renounceKingship() external virtual onlyKing {
        // Call the internal `_renounceKingship` function.
        _renounceKingship();
    }

    // --------------------------------------------------------------- Users Public Read Functions -----------------------------------
    /// @notice Checks if the given address is the current king.
    /// @return `true` if address is the king, otherwise `false`.
    function isKing(address _kingAddress) public view virtual returns (bool) {
        // return `true` if both are equal, `false` otherwise.
        return _kingAddress == s_king;
    }
}
