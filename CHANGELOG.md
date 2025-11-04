# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
