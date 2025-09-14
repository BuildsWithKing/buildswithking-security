// SPDX-License-Identifier: MIT

/// @title Kingable
/// @author Michealking (@BuildsWithKing)
/**
 * @notice Created on the 13th of Sept, 2025.
 *
 *     This contract sets the king at deployment, restricts access to some functions with the modifier "onlyKing".
 *     Allows the king transfer kingship to valid Externally Owned Account (EOA), and renounce kingship to the zero address
 *     (which makes the contract kingless).
 */

/// @dev Abstract contract, to be inherited by other contracts that require king-based access control.

pragma solidity ^0.8.30;

/// @notice Imports ReentrancyGuard.
import {ReentrancyGuard} from "../security/ReentrancyGuard.sol";

abstract contract Kingable is ReentrancyGuard {
    // ----------------------------------------------------------- Custom errors --------------------------------------------------
    /// @notice Thrown when caller is not king.
    /// @dev Thrown when users tries performing king's only operation.
    error Unauthorized(address _user, address _king);

    /// @notice Thrown for same king's address.
    /// @dev Thrown when king tries transferring kingship to self.
    error SameKing(address _king);

    /// @notice Thrown for invalid addresses (zero address, contract addresses).
    /// @dev Thrown when king tries transferring kingship to contract address or address zero.
    error InvalidAddress();
    // ----------------------------------------------------------- Variable assignment --------------------------------------------

    /// @notice Assigns king's address.
    address internal _king;

    // -------------------------------------------------------------- Events ----------------------------------------------------

    /// @notice Emits KingshipTransferred.
    /// @param _oldKingAddress The old king's address.
    /// @param _newKingAddress The new king's address.
    event KingshipTransferred(address indexed _oldKingAddress, address indexed _newKingAddress);

    /// @notice Emits KingshipRenounced.
    /// @param _oldKingAddress The old king's address.
    /// @param _zeroAddress The zero address.
    event KingshipRenounced(address indexed _oldKingAddress, address indexed _zeroAddress);

    // ------------------------------------------------------------- Constructor ---------------------------------------------------

    /// @dev Sets the initial king.
    /// @param _kingAddress The king's address.
    constructor(address _kingAddress) {
        // Revert if king address is the zero or contract address.
        if (_kingAddress == address(0) || _kingAddress.code.length > 0) revert InvalidAddress();

        // Assign king address as king.
        _king = _kingAddress;

        // Emit event KingshipTransferred.
        emit KingshipTransferred(address(0), _kingAddress);
    }

    // ------------------------------------------------------------ Modifier -------------------------------------------------------

    /// @dev Restricts access to onlyKing.
    modifier onlyKing() {
        // Revert if caller is not the king.
        if (msg.sender != _king) revert Unauthorized(msg.sender, _king);
        _;
    }

    // ------------------------------------------------------------- king's internal write functions. ---------------------------------

    /// @notice Transfers kingship.
    /// @param _newKingAddress The new king's address.
    function _transferKingship(address _newKingAddress) internal nonReentrant onlyKing {
        // Assign _currentKing.
        address _currentKing = _king;

        // Revert if new king address is the current king's address.
        if (_currentKing == _newKingAddress) revert SameKing(_currentKing);

        // Revert if new king is zero, this contract, or any contract address.
        if (_newKingAddress == address(0) || _newKingAddress == address(this) || _newKingAddress.code.length > 0) {
            revert InvalidAddress();
        }

        // Assign _newKingAddress as new king.
        _king = _newKingAddress;

        // Emit event KingshipTransferred.
        emit KingshipTransferred(_currentKing, _newKingAddress);
    }

    /// @notice Renounces Kingship.
    function _renounceKingship() internal onlyKing nonReentrant {
        // Assign _currentKing.
        address _currentKing = _king;

        // Emit event KingshipRenounced.
        emit KingshipRenounced(_currentKing, address(0));

        // Assign zero address as new king.
        _king = address(0);
    }

    // ------------------------------------------------------------- King's external write functions. -------------------------------

    /// @notice Transfers kingship.
    /// @param _newKingAddress The new king's address.
    function transferKingship(address _newKingAddress) external virtual onlyKing {
        _transferKingship(_newKingAddress);
    }

    /// @notice Renounces Kingship.
    function renounceKingship() external virtual onlyKing {
        _renounceKingship();
    }

    // --------------------------------------------------- Users public read function. -----------------------------------------------------------

    /// @notice Returns current king's address.
    /// @return Current king's address.
    function currentKing() public view virtual returns (address) {
        // Return king's address.
        return _king;
    }

    /// @notice Return true if _kingAddress is king, otherwise false.
    /// @return true if king, otherwise false.
    function isKing(address _kingAddress) public view virtual returns (bool) {
        // return true if equal, false otherwise.
        return _kingAddress == _king;
    }
}

