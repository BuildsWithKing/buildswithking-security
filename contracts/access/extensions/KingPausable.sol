// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/// @title KingPausable
/// @author Michealking (@BuildsWithKing)
/// @custom:securitycontact buildswithking@gmail.com
/**
 * @notice Created on the 23rd of Sept, 2025.
 *
 *         This contract sets the king at deployment (Initial king can be EOAs or contract address),
 *            restricts access to some functions with the modifier "onlyKing".
 *         Allows the king to pause and activate the contract, and restrict access to some functions using the whenActive modifier.
 *
 *     @dev   Abstract contract, to be inherited by other contracts that require activation-based access control.
 */
abstract contract KingPausable {
    // ----------------------------------------------------------- Custom Errors --------------------------------------------------
    /// @notice Thrown when the caller is not the king.
    /// @dev Thrown when a user tries performing the king's only operation.
    /// @param _user The user's address.
    /// @param _king The king's address.
    error Unauthorized(address _user, address _king);

    /// @notice Thrown for invalid address (zero or this address).
    /// @dev Thrown when the king tries assigning kingship to zero or this contract address.
    /// @param _kingAddress The king's address.
    error InvalidKing(address _kingAddress);

    /// @notice Thrown for paused contract.
    /// @dev Thrown when the contract state is set to Paused.
    error PausedContract();

    /// @notice Thrown for an already active contract.
    /// @dev Thrown when the king tries activating an already active contract.
    error AlreadyActive();

    /// @notice Thrown for an already paused contract.
    /// @dev Thrown when the king tries pausing an already active contract.
    error AlreadyPaused();

    // ----------------------------------------------------------- State Variable --------------------------------------------

    /// @notice Records the king's address.
    address internal s_king;

    /// @notice Records the contract's state.
    bool private s_isActive;
    // -------------------------------------------------------------- Events ----------------------------------------------------

    /// @notice Emitted when the zero address transfers kingship to king at deployment.
    /// @param _zeroAddress The zero address.
    /// @param _newKingAddress The new king's address.
    event KingshipTransferred(address _zeroAddress, address indexed _newKingAddress);

    /// @notice Emitted when the king activates the contract.
    /// @param _kingAddress The king's address.
    event ContractActivated(address indexed _kingAddress);

    /// @notice Emitted when the king pauses the contract.
    /// @param _kingAddress The king's address.
    event ContractPaused(address indexed _kingAddress);

    // ------------------------------------------------------------- Constructor ---------------------------------------------------

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

        // Emit the event KingshipTransferred.
        emit KingshipTransferred(address(0), _kingAddress);
    }

    // ------------------------------------------------------------ Modifiers -------------------------------------------------------

    /// @dev Restricts access to only the king.
    modifier onlyKing() {
        // Revert if caller is not the king.
        if (msg.sender != s_king) revert Unauthorized(msg.sender, s_king);
        _;
    }

    /// @notice Retricts access when the contract is paused.
    /// @dev Retricts access once contract is set to `Paused`.
    modifier whenActive() {
        // Revert `PausedContract` if contract is paused.
        if (!s_isActive) {
            revert PausedContract();
        }
        _;
    }

    // ------------------------------------------------------- King's External Write Functions ---------------------------------------
    /// @notice Activates the contract.
    function _activate() internal onlyKing {
        // Revert if contract is currently active.
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
        // Revert if contract is currently paused.
        if (!s_isActive) {
            revert AlreadyPaused();
        }

        // Set the contract state to paused.
        s_isActive = false;

        // Emit the event ContractPaused.
        emit ContractPaused(s_king);
    }

    // ----------------------------------------------------- King's External Write Functions -----------------------------------------

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

    // -------------------------------------------------------------- Users Public Read Functions ------------------------------------
    /// @notice Returns the current contract state.
    /// @return `true` if the contract is active, `false` if paused.
    function isContractActive() public view virtual returns (bool) {
        // Return contract state.
        return s_isActive;
    }

    /// @notice Returns the current king's address.
    /// @return Current king's address.
    function currentKing() public view virtual returns (address) {
        // Return king's address.
        return s_king;
    }

    /// @notice Checks if the given address is the current king.
    /// @return `true` if address is the king, otherwise `false`.
    function isKing(address _kingAddress) public view virtual returns (bool) {
        // return `true` if both are equal, `false` otherwise.
        return _kingAddress == s_king;
    }
}
