// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/// @title KingVulnerableContract for KingReentrancyAttacker (Local testing only).
/// @author Michealking (@BuildsWithKing).
/// @notice Created on 12th of Oct, 2025.
/// @custom:securitycontact buildswithking@gmail.com

/**
 * @dev This contract lacks security best practices,
 *      and can easily be explored by attackers.
 *
 *      **DO NOT DEPLOY**.
 */
contract KingVulnerableContract {
    // ----------------------------------- Custom Errors ------------------------------------------

    /// @dev Thrown when a user tries depositing ETH lower than mininum.
    error AmountTooLow();

    /// @dev Thrown when a user tries withdrawing on a low balance.
    error BalanceTooLow();

    /// @dev Thrown when a user's withdrawal fails.
    error WithdrawalFailed();

    // ----------------------------------- State Variable --------------------------------------

    /// @notice Records owner's address.
    address immutable i_owner;

    /// @notice Sets minimum deposit amount to 0.001 ETH.
    uint256 constant MINIMUM_DEPOSIT = 0.001 ether;

    // --------------------------------------- Mapping -----------------------------------------------

    /// @dev Maps user's address to their balance.
    mapping(address => uint256) private userBalance;

    // ---------------------------------------- Events ------------------------------------------------

    /// @notice Emitted once a user deposits ETH.
    /// @param _userAddress The user's address.
    /// @param _ethAmount The amount of ETH deposited.
    event EthDeposited(address indexed _userAddress, uint256 _ethAmount);

    /// @notice Emitted once a user withdraws ETH.
    /// @param _userAddress The user's address.
    /// @param _ethAmount The amount of ETH withdrawn.
    event EthWithdrawn(address indexed _userAddress, uint256 _ethAmount);

    // ---------------------------------------- Constructor -------------------------------------------

    /// @notice Set owner as contract deployer.
    constructor() {
        i_owner = msg.sender;
    }

    // --------------------------------------- Private Helper Function ----------------------------------
    /// @notice Accepts users deposit.
    function _vulnerableDeposit() private {
        // Prevent users from depositing ETH less than the minimum.
        if (msg.value < MINIMUM_DEPOSIT) {
            revert AmountTooLow();
        }

        // Add ETH to user's balance.
        unchecked {
            userBalance[msg.sender] += msg.value;
        }

        // Emit the event EthDeposited.
        emit EthDeposited(msg.sender, msg.value);
    }
    // ------------------------------------- Users Write Functions -------------------------------------

    /// @notice Deposits caller's ETH.
    function depositETH() external payable {
        // Call the private `_vulnerableDeposit` helper function.
        _vulnerableDeposit();
    }

    /// @notice Allows users withdraw ETH.
    /// @dev    Reentrancy vulnerability: State update occurs after ETH transfer.
    /// @param _ethAmount The amount of ETH to be withdrawn.
    function withdrawETH(uint256 _ethAmount) external {
        // Prevent users from withdrawing funds greater than their balance.
        if (_ethAmount > userBalance[msg.sender]) {
            revert BalanceTooLow();
        }

        // Fund the user amount withdrawn. Revert if withdrawal fails.
        (bool success,) = payable(msg.sender).call{value: _ethAmount}("");
        if (!success) {
            revert WithdrawalFailed();
        }

        // Emit the event EthWithdrawn.
        emit EthWithdrawn(msg.sender, _ethAmount);
    }

    // ----------------------------------------- Users Read Functions ------------------------------------------

    /// @notice Returns the contract balance.
    /// @return Contract balance.
    function contractBalance() external view returns (uint256) {
        return address(this).balance;
    }

    /// @notice Returns the user's balance.
    /// @return User's balance.
    function myBalance() external view returns (uint256) {
        return userBalance[msg.sender];
    }

    /// @notice Returns the owner's address.
    /// @return Owner's address.
    function owner() external view returns (address) {
        return i_owner;
    }

    // ----------------------------------------- Receive & FallBack Function ----------------------------------

    /// @notice Accepts ETH deposit with no calldata.
    receive() external payable {
        // Call the private `_vulnerableDeposit` helper function.
        _vulnerableDeposit();
    }

    /// @notice Accepts ETH deposit with calldata.
    fallback() external payable {
        // Emit the event EthDeposited.
        emit EthDeposited(msg.sender, msg.value);
    }
}
