## ⚠️ Security Disclaimer

Contracts on this repository has not been audited. Use at your own risk. **Do not use in production environments without proper review**.

# 🔐 BuildsWithKing-Security

![GitHub release (latest by date)](https://img.shields.io/github/v/release/BuildsWithKing/buildswithking-security)
![GitHub](https://img.shields.io/github/license/BuildsWithKing/buildswithking-security)
![GitHub issues](https://img.shields.io/github/issues/BuildsWithKing/buildswithking-security)
![GitHub pull requests](https://img.shields.io/github/issues-pr/BuildsWithKing/buildswithking-security)
![GitHub stars](https://img.shields.io/github/stars/BuildsWithKing/buildswithking-security?style=social)

A lightweight Solidity security utilities library.  
This repository contains reusable, security-focused smart contract modules, inspired by OpenZeppelin’s security patterns, but written from scratch with modern Solidity features.

⚡ Why?  
Instead of just importing libraries, I’m rebuilding core modules to:  
- Understand Solidity security at a deeper level.  
- Explore gas-optimized patterns.  
- Practice rigorous testing (unit, fuzz, invariants).  
- Share my progress openly with the community.

## 🗃️ Features
- Reentrancy protection (NonReentrant)
- Ownership and access control utilities (Kingable)
- Gas-optimized security patterns for modern Solidity. 

## Installation

You can import the contracts directly from GitHub in your Solidity files:


Example: Importing the Reentrancy Guard

```solidity
import "https://github.com/BuildsWithKing/buildswithking-security/blob/main/contracts/security/ReentrancyGuard.sol";
```

> 💡 Note: Always verify the contract code and the specific commit hash before using in production.
For maximum safety, pin to a commit hash instead of main, like this:

```
import "https://github.com/BuildsWithKing/buildswithking-security/blob/<commit-hash>/contracts/security/ReentrancyGuard.sol";
```


You can also install this package into your Foundry/Hardhat project by adding it as a Git submodule or using forge install:

```bash
forge install BuildsWithKing/buildswithking-security
```

Then import any module like:

```
import "buildswithking-security/ReentrancyGuard.sol";
```

## Contributing

Pull requests are welcome! If you’d like to add new security modules or improve existing ones, feel free to fork the repo and submit a PR.

> All PRs will be reviewed for security and code quality before merging.


## Author
Built and maintained by [Michealking (@BuildsWithKing)](https://github.com/BuildsWithKing)


## License

This project is licensed under the [MIT License](https://github.com/BuildsWithKing/buildswithking-security/blob/main/LICENSE).

## Version
Current stable release: [v1.0.0](https://github.com/BuildsWithKing/buildswithking-security/releases/tag/v1.0.0)
