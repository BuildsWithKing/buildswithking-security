## ⚠ Security Disclaimer

This repository has **not been audited**.  
Use at your own risk. **Do not use in production environments without a proper security review.**

---

# 🔐 BuildsWithKing-Security

![GitHub release (latest by date)](https://img.shields.io/github/v/release/BuildsWithKing/buildswithking-security)
![GitHub](https://img.shields.io/github/license/BuildsWithKing/buildswithking-security)
![GitHub issues](https://img.shields.io/github/issues/BuildsWithKing/buildswithking-security)
![GitHub pull requests](https://img.shields.io/github/issues-pr/BuildsWithKing/buildswithking-security)
![GitHub stars](https://img.shields.io/github/stars/BuildsWithKing/buildswithking-security?style=social)

A **lightweight Solidity security utilities library**.  

This repository contains reusable, security-focused smart contract modules, inspired by OpenZeppelin’s battle-tested security patterns, **rebuilt from scratch** with modern Solidity features.

---

## ⚡ Why BuildsWithKing-Security?
Instead of just importing libraries, this project is about rebuilding and learning:  

- 🛡 *Deep Security Understanding* – Writing security primitives line-by-line.  
- ⛽ *Gas-Optimized Patterns* – Exploring efficient implementations.  
- 🧪 *Rigorous Testing* – Unit, fuzz, and invariant tests.  
- 🌍 *Open Source Learning* – Sharing progress with the community.  

---

## 🗃 Features
- 🔒 *Reentrancy Protection* (ReentrancyGuard)  
- 👑 *Ownership & Access Control* (Kingable)  
- ⛽ *Modern Gas-Optimized Security Patterns*

## 📦 Available Modules
- ReentrancyGuard → Prevents reentrant calls  
- Kingable → Custom ownership & access control  

🔜 Coming Soon:  
- Pausable → Emergency stop pattern  
- PullPayment → Safer ETH transfers

---

## 📦 Installation

You can import contracts directly from GitHub in your Solidity files:  

**Example: ReentrancyGuard**

```solidity
import "https://github.com/BuildsWithKing/buildswithking-security/blob/main/contracts/security/ReentrancyGuard.sol";
```

💡 **Best Practice**: Pin to a specific commit hash for safety:  

```solidity
import "https://github.com/BuildsWithKing/buildswithking-security/blob/<commit-hash>/contracts/security/ReentrancyGuard.sol";
```

---

### Option 1: Foundry (Recommended)

```bash
forge install BuildsWithKing/buildswithking-security
```

Specific version:

```bash
forge install BuildsWithKing/buildswithking-security@v1.0.1
```

Add this to foundry.toml: 
```
remappings = [
    "buildswithking-security/=lib/buildswithking-security/contracts/"
]
```

*Usage Example*:  

```solidity
import {Kingable} from "buildswithking-security/access/Kingable.sol";
import {ReentrancyGuard} from "buildswithking-security/security/ReentrancyGuard.sol";

contract MyContract is Kingable, ReentrancyGuard {
    // Your secure logic here
}
```
---

### Option 2: Manual Clone

```bash
git clone --branch v1.0.1 https://github.com/BuildsWithKing/buildswithking-security.git lib/buildswithking-security
```

Then configure your foundry.toml the same way as above.

---

## 🤝 Contributing

Pull requests are welcome! 🚀  
If you’d like to add new security modules or improve existing ones, fork the repo and open a PR.  

> All contributions will be reviewed for *security soundness* and *code quality* before merging.

---

## 👤 Author
Built and maintained by [Michealking (@BuildsWithKing)](https://github.com/BuildsWithKing)

---

## 📜 License
This project is licensed under the [MIT License](https://github.com/BuildsWithKing/buildswithking-security/blob/main/LICENSE).

---

## 📌 Version
Current stable release: [v1.2.0](https://github.com/BuildsWithKing/buildswithking-security/releases/tag/v1.2.0)
