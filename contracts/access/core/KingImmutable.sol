// SPDX-License-Identifier: MIT

/// @title KingImmutable
/// @author Michealking (@BuildsWithKing)
/**
 * @notice Created on the 22nd of Sept, 2025.
 *
 *     This contract sets the king as immutable at deployment, restricts access to some functions with the modifier "onlyKing".
 *         King cannot be changed or renounced.
 *   @dev Abstract contract, to be inherited by other contracts that require immutable king-based access control.
 */
pragma solidity ^0.8.30;

abstract contract KingImmutable {
    // ----------------------------------------------------------- Custom errors --------------------------------------------------
    /// @notice Thrown when caller is not king.
    /// @dev Thrown when users tries performing king's only operation.
    /// @param _user The user's address.
    /// @param _king The king's address.
    error Unauthorized(address _user, address _king);

    /// @notice Thrown for invalid address (zero address).
    /// @dev Thrown when king tries deploying the contract with address zero.
    /// @param _kingAddress The king's address.
    error InvalidKing(address _kingAddress);

    // ----------------------------------------------------------- State variable --------------------------------------------

    /// @notice Assigns king's address.
    address internal immutable s_king;

    // -------------------------------------------------------------- Events -------------------------------------------------------
    /// @notice Emitted once king is assigned at deployment.
    /// @param _kingAddress The immutable king's address.
    event KingshipDeclared(address indexed _kingAddress);

    // ------------------------------------------------------------- Constructor ---------------------------------------------------

    /// @notice Deploys with an immutable king.
    /// @dev Reverts if `_kingAddress` is zero or this contract.
    /// @param _kingAddress The king's address.
    constructor(address _kingAddress) {
        // Revert if `_kingAddress` is the zero or this contract address.
        if (_kingAddress == address(0) || _kingAddress == address(this)) {
            revert InvalidKing(_kingAddress);
        }

        // Assign king address as king.
        s_king = _kingAddress;

        // Emit event KingshipDeclared.
        emit KingshipDeclared(_kingAddress);
    }

    // ------------------------------------------------------------ Modifier ----------------------------------------------------------

    /// @dev Restricts access to onlyKing.
    modifier onlyKing() {
        // Revert if caller is not the king.
        if (msg.sender != s_king) revert Unauthorized(msg.sender, s_king);
        _;
    }

    // --------------------------------------------------- Users public read function. ------------------------------------------------

    /// @notice Checks the current king's address.
    /// @return Current king's address.
    function currentKing() public view virtual returns (address) {
        // Return king's address.
        return s_king;
    }

    // --------------------------------------------------- King's write function. -----------------------------------------------------
    /// @notice Checks if the given address is the current king.
    /// @dev Restricted to king for demonstration/testing of onlyKing modifier.
    /// @return true if king, otherwise false.
    function isKing(address _kingAddress) public view virtual onlyKing returns (bool) {
        // return true if equal, false otherwise.
        return _kingAddress == s_king;
    }
}
