// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/// @title KingablePausable
/// @author Michealking (@BuildsWithKing)
/// @custom:securitycontact buildswithking@gmail.com
/**
 * @notice Created on the 23rd of Sept, 2025.
 *
 *         This contract sets the king at deployment (Initial king can be an EOA or a contract address),
 *            restricts access to some functions with the modifier "onlyKing".
 *         Allows kingship transfer and renouncement, pausing and activating the contract via the "whenActive" modifier.
 *
 *   @dev Abstract contract, to be inherited by contracts that require king-based and activation-based access control.
 */

/// @notice Imports KingAccessControlLite contract.
import {KingAccessControlLite} from "../core/KingAccessControlLite.sol";

abstract contract KingablePausable is KingAccessControlLite {
    // ----------------------------------------------------------- Custom Errors --------------------------------------------------
    /// @notice Thrown for the same king's address.
    /// @dev Thrown when the king tries transferring kingship to self.
    /// @param _king The king's address.
    error SameKing(address _king);

    /// @notice Thrown for invalid new king's address (zero or this contract address).
    /// @dev Thrown when the king tries transferring kingship to the zero or this contract address.
    /// @param _invalidAddress The invalid address.
    error InvalidKing(address _invalidAddress);

    /// @notice Thrown for paused contract.
    /// @dev Thrown when the contract state is set to Paused.
    error PausedContract();

    /// @notice Thrown for an already active contract.
    /// @dev Thrown when the king tries activating an already active contract.
    error AlreadyActive();

    /// @notice Thrown for an already paused contract.
    /// @dev Thrown when the king tries pausing an already active contract.
    error AlreadyPaused();

    // ----------------------------------------------------------- State Variables --------------------------------------------
    /// @notice Records the king's address.
    address public s_king;

    /// @notice Records the contract's state.
    bool private s_isActive;

    // -------------------------------------------------------------- Events --------------------------------------------------
    /// @notice Emitted when the king transfers kingship.
    /// @param _oldKingAddress The old king's address.
    /// @param _newKingAddress The new king's address.
    event KingshipTransferred(address indexed _oldKingAddress, address indexed _newKingAddress);

    /// @notice Emitted when the king renounces kingship.
    /// @param _oldKingAddress The old king's address.
    /// @param _zeroAddress Always the zero address (indicates renouncement).
    event KingshipRenounced(address indexed _oldKingAddress, address _zeroAddress);

    /// @notice Emitted when the king activates the contract.
    /// @param _king The current king's address.
    event ContractActivated(address indexed _king);

    /// @notice Emitted when the king pauses the contract.
    /// @param _king The current king's address.
    event ContractPaused(address indexed _king);

    // ------------------------------------------------------------- Constructor -------------------------------------------------
    /**
     * @dev     Sets the initial king.
     *          Initializes contract state to Active.
     *
     * @param _kingAddress The king's address.
     */
    constructor(address _kingAddress) {
        // Revert if `_kingAddress` is the zero or this contract address.
        if (_kingAddress == address(0) || _kingAddress == address(this)) {
            revert InvalidKing(_kingAddress);
        }

        // Assign _kingAddress as the king.
        s_king = _kingAddress;

        // Set contract state to active on deployment.
        s_isActive = true;

        // Call KingAccessControlLite internal initializer function.
        __KingACL_init(_kingAddress);

        // Emit the event KingshipTransferred.
        emit KingshipTransferred(address(0), _kingAddress);
    }

    // ------------------------------------------------------------ Modifiers -------------------------------------------------------
    /// @notice Retricts access when the contract state is paused.
    /// @dev Retricts access once the contract is set to `Paused`.
    modifier whenActive() {
        // Revert if contract is paused.
        if (!s_isActive) {
            revert PausedContract();
        }
        _;
    }

    // ------------------------------------------------------------- King's Internal Write Functions -----------------------
    /// @notice Transfers kingship to a new address.
    /// @dev Reverts if the new king is the same, zero or this contract address.
    /// @param _newKingAddress The new king's address.
    function _transferKingshipTo(address _newKingAddress) internal onlyKing {
        // Assign _currentKing.
        address _currentKing = s_king;

        // Revert if the new king address is the current king's address.
        if (_currentKing == _newKingAddress) {
            revert SameKing(_currentKing);
        }

        // Revert if the new king is the zero, or this contract address.
        if (_newKingAddress == address(0) || _newKingAddress == address(this)) {
            revert InvalidKing(_newKingAddress);
        }

        // Assign _newKingAddress as new king.
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

        // Assign zero address as the king.
        s_king = address(0);

        // Call KingAccessControlLite `_transferKingRole` internal function. 
        _transferKingRole(address(0));

        // Emit the event KingshipRenounced.
        emit KingshipRenounced(_currentKing, address(0));
    }

    /// @notice Activates the contract.
    function _activate() internal onlyKing {
        // Revert if the contract is currently active.
        if (s_isActive) {
            revert AlreadyActive();
        }

        // Set the contract state to active.
        s_isActive = true;

        // Emit the event ContractActivated.
        emit ContractActivated(s_king);
    }

    /// @notice Pauses the contract.
    function _pause() internal onlyKing {
        // Revert if the contract is currently paused.
        if (!s_isActive) {
            revert AlreadyPaused();
        }

        // Set the contract state to paused.
        s_isActive = false;

        // Emit the event ContractPaused.
        emit ContractPaused(s_king);
    }

    // --------------------------------------------------- King's External Write Functions -------------------------------
    /// @notice Transfers kingship to a new address.
    /// @dev Reverts if the new king is the same, zero or this contract address.
    /// @param _newKingAddress The new king's address.
    function transferKingshipTo(address _newKingAddress) external virtual onlyKing {
        // Call the internal `_transferKingship` function.
        _transferKingshipTo(_newKingAddress);
    }

    /// @notice Renounces Kingship to the zero address.
    function renounceKingship() external virtual onlyKing {
        // Call the internal `_renounceKingship` function.
        _renounceKingship();
    }

    /// @notice Activates the contract.
    function activateContract() external virtual onlyKing {
        // Call the internal `_activate` function.
        _activate();
    }

    /// @notice Pauses the contract.
    function pauseContract() external virtual onlyKing {
        // Call the internal `_pause` function.
        _pause();
    }

    // --------------------------------------------------- Users Public Read Functions ------------------------------------
    /// @notice Checks if the given address is the current king.
    /// @return `true` if address is the king, otherwise `false`.
    function isKing(address _kingAddress) public view virtual returns (bool) {
        return _kingAddress == s_king;
    }

    /// @notice Checks the current contract state.
    /// @return `true` if the contract is active, `false` if paused.
    function isContractActive() public view virtual returns (bool) {
        return s_isActive;
    }
}
