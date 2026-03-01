![GitHub release (latest by date)](https://img.shields.io/github/v/release/BuildsWithKing/buildswithking-security)
![GitHub](https://img.shields.io/github/license/BuildsWithKing/buildswithking-security)
![GitHub issues](https://img.shields.io/github/issues/BuildsWithKing/buildswithking-security)
![GitHub pull requests](https://img.shields.io/github/issues-pr/BuildsWithKing/buildswithking-security)
![GitHub stars](https://img.shields.io/github/stars/BuildsWithKing/buildswithking-security?style=social)
![Tests](https://img.shields.io/badge/tests-100-brightgreen)

# 🔐 BuildsWithKing-Security

Modern, gas-efficient security primitives **for** Solidity  
Minimal. Modular. Rebuilt **from first principles.**

> 💡 Millions of dollars worth of ETH are permanently lost to contracts every year due to preventable mistakes. BuildsWithKing-Security helps developers protect their users from day one.

---

## ⚠ Security Disclaimer

This repository has **not undergone a formal audit**.  
Use at your own risk.  
Always conduct a **security review** before deploying to production.

> 📦 This repo contains contracts only — optimised for lightweight importing.  
> Full test suite (unit tests, fuzz tests, mock contracts) lives here: [buildswithking-kingsecurity](https://github.com/BuildsWithKing/buildswithking-kingsecurity)

---

**BuildsWithKing-Security** provides a collection of lightweight, developer-friendly modules designed to help you build secure smart contracts without unnecessary complexity.

Unlike large frameworks, these modules are:

- Rebuilt from scratch — no copy-pasting OpenZeppelin
- Readable and transparent
- Gas-optimized
- Focused on core security primitives

Inspired by the reliability of OpenZeppelin, but intentionally simpler and more modular for learning, auditing, and extending.

---

## Core Philosophy

- **Security First** — Every module is designed around defensive programming and modern Solidity best practices.
- **Gas Efficiency** — No bloated inheritance chains; minimal storage writes; optimized modifiers.
- **Fully Tested** — Unit tests, fuzz tests and mock contracts via Foundry. [View test suite →](https://github.com/BuildsWithKing/buildswithking-kingsecurity)
- **Educational** — Includes attack simulation contracts so developers understand *why* each protection matters.

---

## 🔑 KingClaimMistakenETH — Self-Service ETH Recovery

Every day, users and developers accidentally send ETH to contract addresses. Without a recovery mechanism, those funds are permanently lost. No admin can help. No support ticket fixes it. The money simply disappears.

**KingClaimMistakenETH** solves this by allowing anyone who accidentally sends ETH to a contract to claim it back themselves — no owner, no admin, no middleman required.

**Features:**
- Self-service recovery — no admin or owner required
- Reentrancy protected via `KingReentrancyGuard`
- Supports alternate address claiming via `claimMistakenETHTo()`
- Tracks total mistaken ETH balance and historical deposits

**Usage:**

```solidity
import {KingClaimMistakenETH} from "@buildswithking-security/access/guards/KingClaimMistakenETH.sol";

contract MyContract is KingClaimMistakenETH {
    // Users can now recover accidentally sent ETH themselves
    // No admin needed. No funds lost forever.
}
```

---

## 🛡 KingReentrancyGuard — Reentrancy Protection

Prevents attackers from draining contracts through recursive calls — one of the most common and costly vulnerabilities in DeFi.

**Features:**
- Lightweight `nonReentrant` modifier
- Gas-optimized lock mechanism
- Compatible with all contract types

**Usage:**

```solidity
import {KingReentrancyGuard} from "@buildswithking-security/access/security/KingReentrancyGuard.sol";

contract MyContract is KingReentrancyGuard {
    function withdraw() external nonReentrant {
        // Protected from reentrancy attacks
    }
}
```

> The library also includes `KingReentrancyAttacker` and `KingVulnerableContract` — educational contracts that demonstrate exactly how reentrancy attacks are constructed and why the CEI pattern and guards are non-negotiable.

---

## Available Modules

### Security Guards
- `KingReentrancyGuard` — Prevents reentrant calls
- `KingClaimMistakenETH` — Self-service recovery for accidentally sent ETH
- `KingRejectETH` — Rejects direct ETH transfers for safety hardening

### Access Control
- `Kingable` — Single owner access control
- `KingAccessControlLite` — Lightweight role-based access
- `KingImmutable` — Immutable owner pattern
- `KingableContracts` — Contract-only access restriction
- `KingableEOAs` — EOA-only access restriction
- `KingablePausable` — Hybrid ownership and pausing

### Emergency Patterns
- `KingPausable` — Pause and activate contracts

### Utilities
- `KingCheckAddressLib` — Address validation library
- `KingReentrancyAttacker` — Attack simulation for testing
- `KingVulnerableContract` — Vulnerable contract for educational use

### ERC20 Implementations
- `KingERC20` — Gas-clean core ERC20 token
- Extensions: `KingERC20Burnable`, `KingERC20Mintable`, `KingERC20Capped`, `KingERC20Pausable`
- Interfaces: `IERC20`, `IERC20Metadata`
- Errors: `KingERC20Errors`

---

## File Structure

```
contracts
├── access
│   ├── core
│   │   ├── KingAccessControlLite.sol
│   │   ├── KingImmutable.sol
│   │   └── Kingable.sol
│   ├── extensions
│   │   ├── KingPausable.sol
│   │   ├── KingableContracts.sol
│   │   ├── KingableEOAs.sol
│   │   └── KingablePausable.sol
│   ├── guards
│   │   ├── KingClaimMistakenETH.sol
│   │   └── KingRejectETH.sol
│   ├── security
│   │   └── KingReentrancyGuard.sol
│   └── utils
│       ├── KingCheckAddressLib.sol
│       ├── KingReentrancyAttacker.sol
│       └── KingVulnerableContract.sol
└── tokens
    ├── ERC20
    │   ├── KingERC20.sol
    │   ├── extensions
    │   │   ├── KingERC20Burnable.sol
    │   │   ├── KingERC20Capped.sol
    │   │   ├── KingERC20Mintable.sol
    │   │   └── KingERC20Pausable.sol
    │   └── interfaces
    │       ├── IERC20.sol
    │       └── IERC20Metadata.sol
    └── errors
        └── KingERC20Errors.sol
```

---

## Installation

### Option 1: Foundry (Recommended)

```bash
forge install BuildsWithKing/buildswithking-security
```

Specific version:

```bash
forge install BuildsWithKing/buildswithking-security@v1.5.0
```

Add this to your `foundry.toml`:

```toml
remappings = [
    "@buildswithking-security/=lib/buildswithking-security/contracts/"
]
```

**Usage Example:**

```solidity
import {Kingable} from "@buildswithking-security/access/core/Kingable.sol";
import {KingReentrancyGuard} from "@buildswithking-security/access/security/KingReentrancyGuard.sol";
import {KingClaimMistakenETH} from "@buildswithking-security/access/guards/KingClaimMistakenETH.sol";

contract MyContract is Kingable, KingReentrancyGuard, KingClaimMistakenETH {
    // Your secure logic here
}
```

### Option 2: Manual Clone

```bash
git clone --branch v1.5.0 https://github.com/BuildsWithKing/buildswithking-security.git lib/buildswithking-security
```

Then configure your `foundry.toml` the same way as above.

### Option 3: Direct Import

Pin to a specific commit hash for safety:

```solidity
import "https://github.com/BuildsWithKing/buildswithking-security/blob/<commit-hash>/contracts/access/security/KingReentrancyGuard.sol";
```

---

## Contributing

Pull requests are welcome!  
If you'd like to add new security modules or improve existing ones, fork the repo and open a PR.

> All contributions will be reviewed for **security soundness** and **code quality** before merging.

---

## Author

Built and maintained by [Michealking (@BuildsWithKing)](https://github.com/BuildsWithKing)  
Solidity Smart Contract Developer | Web3 Security Builder | Foundry

[![Twitter](https://img.shields.io/badge/X%20(Twitter)-000000.svg?style=for-the-badge&logo=twitter&logoColor=white)](https://twitter.com/BuildsWithKing)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-0A66C2.svg?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/michealking-buildswithking-89724434a)

---

## License

This project is licensed under the [MIT License](https://github.com/BuildsWithKing/buildswithking-security/blob/main/LICENSE).

---

## Version

Current stable release: [v1.6.0](https://github.com/BuildsWithKing/buildswithking-security/releases/tag/v1.5.0)
