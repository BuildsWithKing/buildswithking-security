// SPDX-License-Identifier: MIT

/// @title KingPausable
/// @author Michealking (@BuildsWithKing)
/// @custom: security-contact buildswithking@gmail.com
/**
 * @notice Created on the 23rd of Sept, 2025.
 *
 *     This contract sets the king at deployment (Initial king can be EOAs or contract address), restricts access to some functions with the modifier "onlyKing".
 *     Allows the king to pause and activate contract , and restricts access to functions using the whenActive modifier.
 */

/// @dev Abstract contract, to be inherited by other contracts that require king-based access control.

pragma solidity ^0.8.30;

abstract contract KingPausable {
    // ----------------------------------------------------------- Custom errors --------------------------------------------------
    /// @notice Thrown when caller is not king.
    /// @dev Thrown when users tries performing king's only operation.
    /// @param _user The user's address.
    /// @param _king The king's address.
    error Unauthorized(address _user, address _king);

    /// @notice Thrown for invalid address (zero address).
    /// @dev Thrown when king tries assigning kingship to zero or this contract address.
    /// @param _kingAddress The king's address.
    error InvalidKing(address _kingAddress);

    /// @notice Thrown for paused contract.
    /// @dev Thrown when contract state is set to `Paused`.
    error PausedContract();

    /// @notice Thrown for already active contract.
    /// @dev Thrown when king tries activating contract when its already active.
    error AlreadyActive();

    /// @notice Thrown for already paused contract.
    /// @dev Thrown when king tries pausing contract when its already paused.
    error AlreadyPaused();

    // ----------------------------------------------------------- State variable --------------------------------------------

    /// @notice Assigns king's address.
    address internal s_king;

    /// @notice Records contract state.
    ContractState internal s_state;

    // ------------------------------------------------------------ Enums --------------------------------------------------------
    /// @notice Defines contract state.
    /// @dev Contract state can be `Paused` or `Active`.
    enum ContractState {
        Paused,
        Active
    }

    // -------------------------------------------------------------- Events ----------------------------------------------------

    /// @notice Emitted when address zero transfers kingship to king at deployment.
    /// @param _zeroAddress The zero address.
    /// @param _newKingAddress The new king's address.
    event KingshipTransferred(address _zeroAddress, address indexed _newKingAddress);

    /// @notice Emitted when king activates contract.
    /// @param _kingAddress The contract deployer's address.
    event ContractActivated(address indexed _kingAddress);

    /// @notice Emitted when king pauses contract.
    /// @param _kingAddress The contract deployer's address.
    event ContractPaused(address indexed _kingAddress);

    // ------------------------------------------------------------- Constructor ---------------------------------------------------

    /**
     * @dev Sets the initial king (EOA or contract address, but not zero or this contract).
     *     Initializes state to Active.
     *
     *     @param _kingAddress The king's address.
     */
    constructor(address _kingAddress) {
        // Revert if `_kingAddress` is the zero or this contract address.
        if (_kingAddress == address(0) || _kingAddress == address(this)) {
            revert InvalidKing(_kingAddress);
        }

        // Assign king address as king.
        s_king = _kingAddress;

        // Set contract state to active on deployment.
        s_state = ContractState.Active;

        // Emit event KingshipTransferred.
        emit KingshipTransferred(address(0), _kingAddress);
    }

    // ------------------------------------------------------------ Modifiers -------------------------------------------------------

    /// @dev Restricts access to onlyKing.
    modifier onlyKing() {
        // Revert if caller is not the king.
        if (msg.sender != s_king) revert Unauthorized(msg.sender, s_king);
        _;
    }

    /// @notice Retricts access when contract is paused.
    /// @dev Retricts access once contract is set to `Paused`.
    modifier whenActive() {
        // Revert `PausedContract` if contract is paused.
        if (s_state == ContractState.Paused) {
            revert PausedContract();
        }
        _;
    }

    // ------------------------------------------------------------- King's external write functions. -------------------------------
    /// @notice Activates the contract. Only callable by the king.
    function _activate() internal onlyKing {
        // Revert `AlreadyActive` if contract is currently active.
        if (s_state == ContractState.Active) {
            revert AlreadyActive();
        }

        // Set contract state to active.
        s_state = ContractState.Active;

        // Emit event ContractActivated.
        emit ContractActivated(s_king);
    }

    /// @notice Pauses the contract. Only callable by the king.
    function _pause() internal onlyKing {
        // Revert `AlreadyPaused` if contract is currently paused.
        if (s_state == ContractState.Paused) {
            revert AlreadyPaused();
        }

        // Set contract state to paused.
        s_state = ContractState.Paused;

        // Emit event ContractPaused.
        emit ContractPaused(s_king);
    }

    // ------------------------------------------------------------- King's external write functions. -------------------------------

    /// @notice Activates the contract. Only callable by the king.
    function activateContract() external virtual onlyKing {
        // Call internal `_activate` function.
        _activate();
    }

    /// @notice Pauses the contract. Only callable by the king
    function pauseContract() external virtual onlyKing {
        // Call internal `_pause` function.
        _pause();
    }

    // -------------------------------------------------------------- Users public read function. ---------------------------------------
    /// @notice Checks the current contract state.
    /// @dev whenActive was added to this function to verify `whenActive modifier` works as intended.
    /// @return true if contract is active, false if paused.
    function isContractActive() public view virtual whenActive returns (bool) {
        // Return contract state.
        return s_state == ContractState.Active;
    }

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
