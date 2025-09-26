// SPDX-License-Identifier: MIT

/// @title KingableContracts
/// @author Michealking (@BuildsWithKing).
/// @custom: security-contact buildswithking@gmail.com
/**
 * @notice Created on the 22nd of Sept, 2025.
 *
 *     This contract sets the king at deployment (Initial king must be a contract, EOAs are disallowed), restricts access to some functions with the modifier "onlyKing".
 *     Allows the king transfer kingship to contract addresses, and renounce kingship to the zero address
 *     (which makes the contract kingless).
 */

/// @dev Abstract contract, to be inherited by other contracts that require king-based access control.

pragma solidity ^0.8.30;

abstract contract KingableContracts {
    // ----------------------------------------------------------- Custom errors --------------------------------------------------
    /// @notice Thrown when caller is not king.
    /// @dev Thrown when users tries performing king's only operation.
    /// @param _user The user's address.
    /// @param _king The king's address.
    error Unauthorized(address _user, address _king);

    /// @notice Thrown for same king's address.
    /// @dev Thrown when king tries transferring kingship to self.
    /// @param _king The king's address.
    error SameKing(address _king);

    /// @notice Thrown for invalid addresses (zero address, EOAs).
    /// @dev Thrown when king tries transferring kingship to EOAs (code length = 0), address zero, or this contract.
    /// @param _kingAddress The king's address.
    error InvalidKing(address _kingAddress);
    // ----------------------------------------------------------- State variable --------------------------------------------

    /// @notice Assigns king's address.
    address internal s_king;

    // -------------------------------------------------------------- Events ----------------------------------------------------

    /// @notice Emitted when king transfers kingship.
    /// @param _oldKingAddress The old king's address.
    /// @param _newKingAddress The new king's address.
    event KingshipTransferred(address indexed _oldKingAddress, address indexed _newKingAddress);

    /// @notice Emitted when king renounces kingship.
    /// @param _oldKingAddress The old king's address.
    /// @param _zeroAddress Always the zero address (indicates renouncement).
    event KingshipRenounced(address indexed _oldKingAddress, address _zeroAddress);

    // ------------------------------------------------------------- Constructor ---------------------------------------------------

    /// @notice Deploys with an initial contract-only king.
    /// @dev Reverts if `_kingAddress` is zero, an EOA, or this contract.
    /// @param _kingAddress The king's address.
    constructor(address _kingAddress) {
        // Revert if `_kingAddress` is the zero, this contract address or EOAs.
        if (_kingAddress == address(0) || _kingAddress.code.length == 0 || _kingAddress == address(this)) {
            revert InvalidKing(_kingAddress);
        }

        // Assign king address as king.
        s_king = _kingAddress;

        // Emit event KingshipTransferred.
        emit KingshipTransferred(address(0), _kingAddress);
    }

    // ------------------------------------------------------------ Modifier -------------------------------------------------------

    /// @dev Restricts access to onlyKing.
    modifier onlyKing() {
        // Revert if caller is not the king.
        if (msg.sender != s_king) revert Unauthorized(msg.sender, s_king);
        _;
    }

    // ------------------------------------------------------------- king's internal write functions. ---------------------------------

    /// @notice Transfers kingship to another contract.
    /// @dev Reverts if _newKingAddress is zero, an EOA, this contract, or the same as current.
    /// @param _newKingAddress The new king's contract address.
    function _transferKingshipTo(address _newKingAddress) internal onlyKing {
        // Assign _currentKing.
        address _currentKing = s_king;

        // Revert if new king address is the current king's address.
        if (_currentKing == _newKingAddress) revert SameKing(_currentKing);

        // Revert if new king is zero, this contract, or EOAs.
        if (_newKingAddress == address(0) || _newKingAddress == address(this) || _newKingAddress.code.length == 0) {
            revert InvalidKing(_newKingAddress);
        }

        // Assign _newKingAddress as new king.
        s_king = _newKingAddress;

        // Emit event KingshipTransferred.
        emit KingshipTransferred(_currentKing, _newKingAddress);
    }

    /// @notice Renounces Kingship to the zero address.
    function _renounceKingship() internal onlyKing {
        // Assign _currentKing.
        address _currentKing = s_king;

        // Assign zero address as new king.
        s_king = address(0);

        // Emit event KingshipRenounced.
        emit KingshipRenounced(_currentKing, address(0));
    }

    // ------------------------------------------------------------- King's external write functions. -------------------------------

    /// @notice Transfers kingship to another contract.
    /// @dev Reverts if _newKingAddress is zero, an EOA, this contract, or the same as current.
    /// @param _newKingAddress The new king's contract address.
    function transferKingshipTo(address _newKingAddress) external virtual onlyKing {
        _transferKingshipTo(_newKingAddress);
    }

    /// @notice Renounces Kingship to the zero address.
    function renounceKingship() external virtual onlyKing {
        _renounceKingship();
    }

    // --------------------------------------------------- Users public read function. -----------------------------------------------------------

    /// @notice Checks the current king's address.
    /// @return Current king's address.
    function currentKing() public view virtual returns (address) {
        // Return king's address.
        return s_king;
    }

    /// @notice Checks if the given address is the current king.
    /// @return true if king, otherwise false.
    function isKing(address _kingAddress) public view virtual returns (bool) {
        // return true if equal, false otherwise.
        return _kingAddress == s_king;
    }
}
