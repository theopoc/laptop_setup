# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.3.0](https://github.com/TheoPoc/laptop_setup/compare/v1.2.3...v1.3.0) (2025-11-09)

### ✨ Features

* **playbook:** enable appstore role for Mac App Store applications ([dfce0e7](https://github.com/TheoPoc/laptop_setup/commit/dfce0e702f1b8655b2992004a473871d077478b4))

### 🔧 Chores

* **deps:** pin community.general to version >=12.0.0 ([c2a2f27](https://github.com/TheoPoc/laptop_setup/commit/c2a2f27cc371167cd39174e4d544a21ec7c5ce05))
* **deps:** remove unused Ansible dependencies ([2074a93](https://github.com/TheoPoc/laptop_setup/commit/2074a93acf7f0aacc4fbcfa6d47cb6770bb7155d))

## [1.2.3](https://github.com/TheoPoc/laptop_setup/compare/v1.2.2...v1.2.3) (2025-11-09)

### 🐛 Bug Fixes

* **vim:** restore OS-specific vim_group variable ([0fa3058](https://github.com/TheoPoc/laptop_setup/commit/0fa30587e0fbf3e0137aa96b686cb923ce9ac722))

### 📚 Documentation

* emphasize Git configuration requirement in README ([c21c05e](https://github.com/TheoPoc/laptop_setup/commit/c21c05e923f9f6455d0c2aae1b24ce0b89910c17))
* prepare repository for public release ([f061da4](https://github.com/TheoPoc/laptop_setup/commit/f061da486c3d6a4d051756c9960d363fda578ef4))
* remove SSH key generation steps for public repository ([015fb6c](https://github.com/TheoPoc/laptop_setup/commit/015fb6cc93372f4d0a5a0836c420c37e6ed9a286))
* update repository references from ansible-mgmt-laptop to laptop_setup ([fcb786c](https://github.com/TheoPoc/laptop_setup/commit/fcb786c76accdfdc617016b3c3880287b3d459cd))

### ♻️ Code Refactoring

* remove unnecessary ansible_user from inventory ([08d324c](https://github.com/TheoPoc/laptop_setup/commit/08d324ce0ef1f8f476d8ad851c7246ed41bffcbc))
* use ansible_user_id directly instead of intermediate variables ([132d0a4](https://github.com/TheoPoc/laptop_setup/commit/132d0a4b900ea09386c0b680abad1eaad71c2792))
* **zsh:** use ansible_user_id instead of ansible_user ([690c259](https://github.com/TheoPoc/laptop_setup/commit/690c259851b6d4b2cfe663efef10ec9791652472))

### 👷 CI/CD

* remove dependabot auto-approve job and references ([4f53e4f](https://github.com/TheoPoc/laptop_setup/commit/4f53e4f336856dfc5ec289763cc2ba729474d03e))
* **workflow:** simplify CI workflow triggers ([8599e31](https://github.com/TheoPoc/laptop_setup/commit/8599e313a88b8816af97da6970e44c9aaca0fbc8))

### 🔧 Chores

* **deps:** Update GitHub Actions ([71c67b0](https://github.com/TheoPoc/laptop_setup/commit/71c67b0398c47f7b0ab5bc8f92013dd4df76caf2))
* **deps:** Update npm dependencies ([702801f](https://github.com/TheoPoc/laptop_setup/commit/702801fa54895b399f280e0f435e146e687d60cf))
* **renovate:** disable pin digest updates for GitHub Actions ([8908c41](https://github.com/TheoPoc/laptop_setup/commit/8908c41d33f8d371653afb1f700f9c679478639c))

## [1.2.2](https://github.com/TheoPoc/ansible-mgmt-laptop/compare/v1.2.1...v1.2.2) (2025-11-05)

### 📚 Documentation

* add Git workflow section with mandatory PR policy to CLAUDE.md ([c11a902](https://github.com/TheoPoc/ansible-mgmt-laptop/commit/c11a9025e05f8d4a4004697d8c85e08c16ddd358))
* add Semantic Release and Renovate badges to README ([85f46cc](https://github.com/TheoPoc/ansible-mgmt-laptop/commit/85f46cce436b1edffdda312c48034863c75a5ac3))

### ♻️ Code Refactoring

* use native GitHub Actions branch filters to control CI execution ([ed05e1e](https://github.com/TheoPoc/ansible-mgmt-laptop/commit/ed05e1e5d9975548e015863f887ab93e2c69e1a7))

## [1.2.1](https://github.com/TheoPoc/ansible-mgmt-laptop/compare/v1.2.0...v1.2.1) (2025-11-04)

### 🐛 Bug Fixes

* analyze commit message for both push and PR events in CI workflow ([f0e3209](https://github.com/TheoPoc/ansible-mgmt-laptop/commit/f0e32095e449d787bac29e2fb668bc72e374d45f))

### 👷 CI/CD

* skip CI pipeline for chore commits to optimize workflow execution ([080f001](https://github.com/TheoPoc/ansible-mgmt-laptop/commit/080f00123e3edf3286cc3201e4a01aafb1e8ff12))

### 🔧 Chores

* **deps:** migrate config renovate.json ([6cd5e57](https://github.com/TheoPoc/ansible-mgmt-laptop/commit/6cd5e576c5f584a13a5cf8ec1e1b07dc26fd06a6))

## [1.2.0](https://github.com/TheoPoc/ansible-mgmt-laptop/compare/v1.1.0...v1.2.0) (2025-11-04)

### ✨ Features

* add Renovate for automated dependency management ([4863f19](https://github.com/TheoPoc/ansible-mgmt-laptop/commit/4863f193acc42b2594d48529367349dcfcf4887b))
* **release:** trigger patch releases for dependency updates ([bc5b285](https://github.com/TheoPoc/ansible-mgmt-laptop/commit/bc5b285885b18d99abf54eecf438a29c71e5e435))
* **renovate:** require all CI checks to pass before auto-merge ([c18e9c1](https://github.com/TheoPoc/ansible-mgmt-laptop/commit/c18e9c181b3275cf57bbc66f31c80ae1426a1ed3))

### 🐛 Bug Fixes

* remove extra quote in .releaserc.json causing JSON parse error ([7751964](https://github.com/TheoPoc/ansible-mgmt-laptop/commit/775196410016718795e18865ff9cbc38662ef554))

## [1.1.0](https://github.com/TheoPoc/ansible-mgmt-laptop/compare/v1.0.0...v1.1.0) (2025-11-04)

### ✨ Features

* implement automatic semantic release workflow ([3950620](https://github.com/TheoPoc/ansible-mgmt-laptop/commit/3950620da039fd8e091a0b7c0a87cda9483fd371))

### ♻️ Code Refactoring

* manage semantic-release dependencies via package.json ([18d4e64](https://github.com/TheoPoc/ansible-mgmt-laptop/commit/18d4e64745e02b49a256b16cd7f2111a81d83a1f))
