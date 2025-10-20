// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/// @title KingReentrancyGuard
/// @author Michealking (@BuildsWithKing).
/// @custom:securitycontact buildswithking@gmail.com
/**
 * @notice Created on the 24th of Aug, 2025.
 *         Updated on the 8th of Oct, 2025.
 *
 * @dev    A reentrancy guard is a piece of code that causes execution to fail when reentrancy is detected.
 *         This provides the "nonReentrant" modifier. Applying this modifier to a function will render it “non-reentrant”,
 *         and attempts to re-enter the function will be rejected by reverting the call.
 */
abstract contract KingReentrancyGuard {
    // ------------------------------------------------ Custom Error -------------------------------------------
    /// @dev Thrown when function state is locked.
    error NoReentrant();

    // ------------------------------------------------ State Variable -----------------------------------------
    /// @notice Records function's state.
    bool private s_isLocked;

    // ---------------------------------------------------- Modifier --------------------------------------------
    /// @dev Restricts a function from being reentered.
    modifier nonReentrant() {
        // Revert if locked.
        if (s_isLocked) {
            revert NoReentrant();
        }

        // Lock before executing the function.
        s_isLocked = true;
        _;

        // Unlock after the execution.
        s_isLocked = false;
    }
}
