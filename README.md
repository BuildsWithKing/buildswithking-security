
![GitHub release (latest by date)](https://img.shields.io/github/v/release/BuildsWithKing/buildswithking-security)
![GitHub](https://img.shields.io/github/license/BuildsWithKing/buildswithking-security)
![GitHub issues](https://img.shields.io/github/issues/BuildsWithKing/buildswithking-security)
![GitHub pull requests](https://img.shields.io/github/issues-pr/BuildsWithKing/buildswithking-security)
![GitHub stars](https://img.shields.io/github/stars/BuildsWithKing/buildswithking-security?style=social)


# 🔐 BuildsWithKing-Security
Modern, gas-efficient security primitives **for** Solidity  
Minimal. Modular. Rebuilt **from first** principles.

## ⚠ Security Disclaimer

This repository has **not undergone a formal audit**.
Use at your own risk.
Always conduct a **security review** before deploying to production.

---

**BuildsWithKing-Security** provides a collection of lightweight, developer-friendly modules designed to help you build secure smart contracts without unnecessary complexity.

Unlike large frameworks, these modules are:

- Rebuilt from scratch

- Readable and transparent

- Gas-optimized

- Focused on core security primitives

Inspired by the reliability of OpenZeppelin, but intentionally simpler and more modular for learning, auditing, and extending.

---

## Core Philosophy

- **Security First**:
Every module is designed around defensive programming and modern Solidity best practices.

- **Gas Efficiency**:
No bloated inheritance chains; minimal storage writes; optimized modifiers.

- **[Fully Tested](https://github.com/BuildsWithKing/buildswithking-kingsecurity)**:
Includes unit and fuzz tests (Foundry).

- **Educational**:
Ideal for both learning and production.

---

## Features
- *Reentrancy Protection* (KingReentrancyGuard)  
- *Ownership & Access Control* (Kingable)  
- *Modern Gas-Optimized Security Patterns*

## Available Modules

### Security Guards

KingReentrancyGuard — Prevents reentrant calls

KingClaimMistakenETH — Recover accidental ETH transfers

KingRejectETH — Reject direct ETH transfers (safety hardening)


### Access Control

- Kingable — Ownership

- KingAccessControlLite — Lightweight role-based access

- KingImmutable — Immutable owner pattern

- KingableContracts — Contract-only access

- KingableEOAs — EOA-only access

- KingablePausable — Hybrid access × pausing


### Emergency Patterns

KingPausable — pause/active contract.


### ERC20 Implementations

KingERC20 — Gas-clean core token

- Extensions:

  - Burnable

  - Mintable

  - Capped

  - Pausable

- Interfaces: IERC20, IERC20Metadata

- ERC20 error contract: KingERC20Errors

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

You can import contracts directly from GitHub in your Solidity files:  

**Example: ReentrancyGuard**

```solidity
import "https://github.com/BuildsWithKing/buildswithking-security/blob/main/contracts/access/security/KingReentrancyGuard.sol";
```

 **Best Practice**: Pin to a specific commit hash for safety:  

```solidity
import "https://github.com/BuildsWithKing/buildswithking-security/blob/<commit-hash>/contracts/access/security/KingReentrancyGuard.sol";
```

---

### Option 1: Foundry (Recommended)

```bash
forge install BuildsWithKing/buildswithking-security
```

Specific version:

```bash
forge install BuildsWithKing/buildswithking-security@v1.5.0
```

Add this to foundry.toml: 
```
remappings = [
    "buildswithking-security/=lib/buildswithking-security/contracts/"
]
```

*Usage Example*:  

```solidity
import {Kingable} from "buildswithking-security/access/core/Kingable.sol";
import {KingReentrancyGuard} from "buildswithking-security/access/security/KingReentrancyGuard.sol";

contract MyContract is Kingable, KingReentrancyGuard {
    // Your secure logic here
}
```
---

### Option 2: Manual Clone

```bash
git clone --branch v1.5.0 https://github.com/BuildsWithKing/buildswithking-security.git lib/buildswithking-security
```

Then configure your foundry.toml the same way as above.

---

## Contributing

Pull requests are welcome!  
If you’d like to add new security modules or improve existing ones, fork the repo and open a PR.  

> All contributions will be reviewed for *security soundness* and *code quality* before merging.

---

## Author
Built and maintained by [Michealking (@BuildsWithKing)](https://github.com/BuildsWithKing)

---

## License
This project is licensed under the [MIT License](https://github.com/BuildsWithKing/buildswithking-security/blob/main/LICENSE).

---

## Version
Current stable release: [v1.5.0](https://github.com/BuildsWithKing/buildswithking-security/releases/tag/v1.5.0)
