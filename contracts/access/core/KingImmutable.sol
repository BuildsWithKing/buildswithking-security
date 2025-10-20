// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/// @title KingImmutable
/// @author Michealking (@BuildsWithKing)
/// @custom:securitycontact buildswithking@gmail.com
/**
 * @notice Created on the 22nd of Sept, 2025.
 *
 *         This contract sets the king as immutable at deployment, restricts access to some functions with the modifier "onlyKing".
 *         King cannot be changed or renounced.
 *  @dev   Abstract contract, to be inherited by other contracts that require immutable king-based access control.
 */
abstract contract KingImmutable {
    // ----------------------------------------------------------- Custom Errors -------------------------------------------
    /// @notice Thrown when the caller is not the king.
    /// @dev Thrown when a user tries performing the king's only operation.
    /// @param _user The user's address.
    /// @param _king The king's address.
    error Unauthorized(address _user, address _king);

    /// @notice Thrown for invalid address (zero or this contract address).
    /// @dev Thrown when the king tries deploying the contract with the zero or this contract address.
    /// @param _invalidAddress The invalid address.
    error InvalidKing(address _invalidAddress);

    // ----------------------------------------------------------- State Variable --------------------------------------------

    /// @notice Records the king's address.
    address internal immutable s_king;

    // -------------------------------------------------------------- Event --------------------------------------------------
    /// @notice Emitted once the king is assigned at deployment.
    /// @param _kingAddress The immutable king's address.
    event KingshipDeclared(address indexed _kingAddress);

    // ------------------------------------------------------------- Constructor ---------------------------------------------

    /// @notice Deploys with an immutable king.
    /// @dev Reverts if `_kingAddress` is the zero or this contract address.
    /// @param _kingAddress The king's address.
    constructor(address _kingAddress) {
        // Revert if `_kingAddress` is the zero or this contract address.
        if (_kingAddress == address(0) || _kingAddress == address(this)) {
            revert InvalidKing(_kingAddress);
        }

        // Assign _kingAddress as the king.
        s_king = _kingAddress;

        // Emit event KingshipDeclared.
        emit KingshipDeclared(_kingAddress);
    }

    // ------------------------------------------------------------ Modifier ----------------------------------------------------------

    /// @dev Restricts access to only the king.
    modifier onlyKing() {
        // Revert if caller is not the king.
        if (msg.sender != s_king) {
            revert Unauthorized(msg.sender, s_king);
        }
        _;
    }

    // --------------------------------------------------- Users Public Read Functions ------------------------------------------------
    /// @notice Checks if the given address is the current king.
    /// @return `true` if address is the king, otherwise `false`.
    function isKing(address _kingAddress) public view virtual returns (bool) {
        // return `true` if both are equal, `false` otherwise.
        return _kingAddress == s_king;
    }

    /// @notice Returns the current king's address.
    /// @return The current king's address.
    function currentKing() public view virtual returns (address) {
        // Return king's address.
        return s_king;
    }
}
