// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/// @title KingClaimMistakenETH.
/// @author Michealking (@BuildsWithKing).
/// @custom:securitycontact buildswithking@gmail.com

/**
 * @notice Created on the 8th of Oct, 2025.
 *
 * @dev     Abstract contract to be inherited by contracts that allows users claim ETH mistakenly transferred.
 *          This contract is designed for EOAs who mistakenly send ETH, Contracts can still deposit,
 *          but won't typically need to claim.
 *
 *          Remember to import KingPausable or KingablePausable for activation-based access control, use the "whenActive" modifier
 *          on the claimMistakenETH and claimMistakenETHTo external functions.
 *
 */

/// @notice Imports KingReentrancyGuard contract.
import {KingReentrancyGuard} from "../security/KingReentrancyGuard.sol";

abstract contract KingClaimMistakenETH is KingReentrancyGuard {
    // ------------------------------------------------------------------- Custom Error ------------------------------------------
    /// @notice Thrown for zero ETH transfers.
    /// @dev Thrown when a user mistakenly transfers zero ETH.
    error AmountTooLow();

    /// @notice Thrown when a user inputs the zero or this contract address as alternate address.
    /// @dev Thrown when a user inputs the zero or this contract address as alternate address.
    error InvalidAddress(address _invalidAddress);

    /// @notice Thrown for zero balance.
    /// @dev Thrown when a user with zero balance tries to claim ETH.
    error InsufficientFunds();

    /// @notice Thrown for failed claim transaction.
    /// @dev Thrown when a user's claim fails.
    error ClaimFailed();

    // ------------------------------------------------------------------- State Variable ----------------------------------------
    /// @notice Records total mistaken ETH (Contract balance).
    uint256 private s_totalMistakenETH;

    /// @notice Records total mistaken ETH ever deposited.
    uint256 private s_totalRecordedMistakenETH;

    // ------------------------------------------------------------------- Mapping -----------------------------------------------
    /// @notice Maps users address to the ETH they mistakenly transferred.
    /// @dev Maps users address to the ETH mistakenly transferred.
    mapping(address => uint256) private s_mistakenETHBalance;

    // ------------------------------------------------------------------- Events ------------------------------------------------
    /// @notice Emitted when a user successfully claims ETH mistakenly transferred.
    /// @param _userAddress The user's address.
    /// @param _alternateAddress The user's or alternate address.
    /// @param _ethAmount The amount of ETH claimed.
    event MistakenETHClaimed(address indexed _userAddress, address indexed _alternateAddress, uint256 _ethAmount);

    /// @notice Emitted when a user mistakenly transfers ETH.
    /// @param _userAddress The user's address.
    /// @param _ethAmount The amount of ETH deposited.
    event MistakenETHDeposited(address indexed _userAddress, uint256 _ethAmount);

    // ---------------------------------------------------------------- Private Helper Function -----------------------------------
    /// @notice Accepts ETH mistakenly transferred.
    /// @dev Accepts users deposit through receive & fallback.
    function _depositETH() private {
        // Revert if user's deposit is equal to zero.
        if (msg.value == 0) {
            revert AmountTooLow();
        }

        unchecked {
            // Add amount to user's balance.
            s_mistakenETHBalance[msg.sender] += msg.value;

            // Add amount to total mistaken ETH.
            s_totalMistakenETH += msg.value;

            // Add amount to total recorded mistaken ETH.
            s_totalRecordedMistakenETH += msg.value;
        }

        // Emit the event MistakenETHDeposited.
        emit MistakenETHDeposited(msg.sender, msg.value);
    }

    // ------------------------------------------------------------------- Users Internal Write Function ----------------------------
    /// @notice Allows caller to claim ETH they mistakenly deposited.
    /// @param _alternateAddress The user's or alternate address.
    function _claimETH(address _alternateAddress) internal nonReentrant {
        // Revert if _alternateAddress is the zero or this contract address.
        if (_alternateAddress == address(0) || _alternateAddress == address(this)) {
            revert InvalidAddress(_alternateAddress);
        }

        // Assign the caller's balance.
        uint256 _userBalance = s_mistakenETHBalance[msg.sender];

        // Revert `InsufficientFunds` for zero balance.
        if (_userBalance == 0) {
            revert InsufficientFunds();
        }

        // Subtract the caller's balance from the total mistaken ETH.
        unchecked {
            s_totalMistakenETH -= _userBalance;
        }

        // Set caller's mistaken ETH balance to zero.
        s_mistakenETHBalance[msg.sender] = 0;

        // Fund _alternateAddress the entire caller's balance.
        (bool success,) = payable(_alternateAddress).call{value: _userBalance}("");
        if (!success) {
            revert ClaimFailed();
        }

        // Emit the event MistakenETHClaimed.
        emit MistakenETHClaimed(msg.sender, _alternateAddress, _userBalance);
    }

    // ----------------------------------------------------------- Users External Write Function ----------------------------------
    /// @notice Allows caller to claim ETH they mistakenly deposited.
    function claimMistakenETH() external {
        // Call the internal "_claimETH" function.
        _claimETH(msg.sender);
    }

    /// @notice Allows caller transfer ETH to an alternate address.
    /// @param _alternateAddress The alternate address.
    function claimMistakenETHTo(address _alternateAddress) external {
        // Call the internal "_claimETH" function.
        _claimETH(_alternateAddress);
    }

    // ------------------------------------------------------------- Users Public Read Function ----------------------------------
    /// @notice Returns caller's mistaken ETH balance.
    /// @return Caller's mistaken ETH balance.
    function myMistakenETHBalance() public view returns (uint256) {
        return s_mistakenETHBalance[msg.sender];
    }

    /// @notice Returns address's mistaken ETH balance.
    /// @return Address's mistaken ETH balance.
    function userMistakenETHBalance(address _userAddress) public view returns (uint256) {
        return s_mistakenETHBalance[_userAddress];
    }

    /// @notice Returns contract's total mistaken ETH balance.
    /// @return Contract's mistaken ETH balance.
    function totalMistakenETH() public view returns (uint256) {
        return s_totalMistakenETH;
    }

    /// @notice Returns Total mistaken ETH ever deposited.
    /// @return Total mistaken ETH ever deposited.
    function totalRecordedMistakenETH() public view returns (uint256) {
        return s_totalRecordedMistakenETH;
    }

    // ----------------------------------------------------------- Receive & Fallback Function ------------------------------------
    /// @notice Handles Mistaken ETH deposit with no calldata.
    receive() external payable {
        // Call the private `_depositETH` function.
        _depositETH();
    }

    /// @notice Handles Mistaken ETH deposit with calldata.
    fallback() external payable {
        // Call the private `_depositETH` function.
        _depositETH();
    }
}
