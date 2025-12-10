# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.7.1](https://github.com/TheoPoc/laptop_setup/compare/v1.7.0...v1.7.1) (2025-12-10)

### 🐛 Bug Fixes

* mysql client package name for debian ([496d9b4](https://github.com/TheoPoc/laptop_setup/commit/496d9b4661ff32a66946d573e202b29518972256))

## [1.7.0](https://github.com/TheoPoc/laptop_setup/compare/v1.6.0...v1.7.0) (2025-12-10)

### ✨ Features

* **roles:** add Debian 12 compatibility for all non-macOS roles ([3aa0f4c](https://github.com/TheoPoc/laptop_setup/commit/3aa0f4c308f6e25f0ce0ee38b8894d31e17e74fb))
* update roles to reflect Ubuntu 24.04 and Debian 12 compatibility ([5cac6d8](https://github.com/TheoPoc/laptop_setup/commit/5cac6d844841940b716ec52fff8cd98fe78a7c0a))

### 🔧 Chores

* disable Git configuration by default ([4876f89](https://github.com/TheoPoc/laptop_setup/commit/4876f89a46faa461b0ed64042e64de9bd8778fca))

## [1.6.0](https://github.com/TheoPoc/laptop_setup/compare/v1.5.2...v1.6.0) (2025-11-24)

### ✨ Features

* **config:** replace Arc browser with Dia browser ([5ae587a](https://github.com/TheoPoc/laptop_setup/commit/5ae587a48230cbcf00addc591c5aded5dac7c799))

### 📚 Documentation

* **claude:** add GitHub MCP workflow investigation guidance ([769912e](https://github.com/TheoPoc/laptop_setup/commit/769912e9f275fbb5fbb32a5fb5f7312780583bfc))
* **claude:** update molecule tests role list and document macOS-only roles ([09577d5](https://github.com/TheoPoc/laptop_setup/commit/09577d57af3bf2f9de1e519d48c448bde8d993ee))

### 👷 CI/CD

* **workflow:** add scheduled execution every Saturday at 3pm Paris time ([7e2a003](https://github.com/TheoPoc/laptop_setup/commit/7e2a00330898f5766a0d8c88c7435debf47e8764))

## [1.5.2](https://github.com/TheoPoc/laptop_setup/compare/v1.5.1...v1.5.2) (2025-11-13)

### 🐛 Bug Fixes

* **ci:** correct output reference after step consolidation ([d2ff0ab](https://github.com/TheoPoc/laptop_setup/commit/d2ff0abab60991237348d168e519a36120edffd7))
* **ci:** exclude macOS-only roles from Ubuntu CI tests ([81d0694](https://github.com/TheoPoc/laptop_setup/commit/81d069401683b1f7058d35cdae12d3cb029eefad))
* **ci:** skip test-roles job when no roles to test ([5b00770](https://github.com/TheoPoc/laptop_setup/commit/5b007709c28b6d1bca81baa040d918400288e848))

### ♻️ Code Refactoring

* **ci:** combine role discovery and filter generation into single step ([e2ac544](https://github.com/TheoPoc/laptop_setup/commit/e2ac54420c418a0c596d42671d17f0277abf4d71))

## [1.5.1](https://github.com/TheoPoc/laptop_setup/compare/v1.5.0...v1.5.1) (2025-11-12)

### ⚡ Performance Improvements

* **ci:** ensure all roles tested on main branch ([89385b3](https://github.com/TheoPoc/laptop_setup/commit/89385b3bb4fcc736c4f2d4a69208b0897aedcb4c))
* **ci:** optimize pipeline to test only changed roles ([edf0e24](https://github.com/TheoPoc/laptop_setup/commit/edf0e24237b17e04036ec8234ac20c70adac2efa))

### ♻️ Code Refactoring

* **ci:** make role discovery fully dynamic ([c3d42b2](https://github.com/TheoPoc/laptop_setup/commit/c3d42b221beeb4eac1859e5b6be037ba308a5e07))

### 👷 CI/CD

* **renovate:** change schedule to saturday at 2pm ([9f7610a](https://github.com/TheoPoc/laptop_setup/commit/9f7610a9b519b6d4a34feb5001ee40adf584521a))

## [1.5.0](https://github.com/TheoPoc/laptop_setup/compare/v1.4.0...v1.5.0) (2025-11-12)

### ✨ Features

* **ci:** configure molecule-action to use ubuntu 24.04 container image ([23aff64](https://github.com/TheoPoc/laptop_setup/commit/23aff6451acf78309ec4da01166019da42dc1a9e))
* **ci:** migrate to gofrolist/molecule-action for better molecule testing ([0baf2c0](https://github.com/TheoPoc/laptop_setup/commit/0baf2c093bb4b9fd17c3912bd4b9c86fb4ac9c0e))

### 🐛 Bug Fixes

* **ci:** add missing warp_enabled variable to group_vars ([5bd588e](https://github.com/TheoPoc/laptop_setup/commit/5bd588e8b74881d59bcb548733c77c506ab5c171))
* **ci:** checkout to github.repository path for molecule-action compatibility ([ce21892](https://github.com/TheoPoc/laptop_setup/commit/ce2189221b5c507eb92e239e5189f813f8b7b094))
* **ci:** correct working-directory indentation in molecule-action step ([4d099f4](https://github.com/TheoPoc/laptop_setup/commit/4d099f4663d8732bc9d9b941264b497403fdcdfe))
* **ci:** revert to manual ansible-lint installation to fix compatibility issues ([1873238](https://github.com/TheoPoc/laptop_setup/commit/187323882d20842d720584d35cbff9216ced8d4a))
* **ci:** use ANSIBLE_ROLES_PATH instead of MOLECULE_ROLE_PATH ([bf981aa](https://github.com/TheoPoc/laptop_setup/commit/bf981aad86c36e6346b4700c63c3e2745b797618))
* **ci:** use correct molecule command syntax --debug test ([be32988](https://github.com/TheoPoc/laptop_setup/commit/be3298857eebc288f96b2efa82ef24236ff68e8c))
* **ci:** use only --debug flag for molecule command ([c959006](https://github.com/TheoPoc/laptop_setup/commit/c959006fe1e4162a116ace65d4dda7415766c164))
* **ci:** use working-directory instead of directory parameter for molecule-action ([40aa4cf](https://github.com/TheoPoc/laptop_setup/commit/40aa4cf45b34b0dc70d08b3f99080849d5687947))
* **test:** change molecule driver from podman to docker ([9b3ea39](https://github.com/TheoPoc/laptop_setup/commit/9b3ea390dccbe895ec1a4b700e71bff4f4dbe463))
* **test:** remove deprecated ansible property from molecule.yml files ([075bc19](https://github.com/TheoPoc/laptop_setup/commit/075bc19f8452dd65da1eed9e6b27672c1beba51e))

### ⚡ Performance Improvements

* **ci:** replace manual ansible-lint with official GitHub Action ([c32f469](https://github.com/TheoPoc/laptop_setup/commit/c32f4699740c58b2c2ba3b3dbf6366dcfad0e00e))
* **ci:** streamline ansible syntax validation with GitHub Action ([6c5a692](https://github.com/TheoPoc/laptop_setup/commit/6c5a692d2c3fa7c7ef4a5a34e0f70a199bd4c150))
* **ci:** use ansible-playbook action for integration test ([dcd23b4](https://github.com/TheoPoc/laptop_setup/commit/dcd23b4b75b35a7296eda7f7c128a9ab706c47b3))

### ✅ Tests

* **ci:** try MOLECULE_ROLE_PATH env var to specify role directory ([3b67f67](https://github.com/TheoPoc/laptop_setup/commit/3b67f67a49da56248f1d1916a7169f7f242d65b1))

### 👷 CI/CD

* **pipeline:** enforce yamllint failures by removing continue-on-error ([ad85ed5](https://github.com/TheoPoc/laptop_setup/commit/ad85ed5739f7f32a2eac69f37ca09daaf07b97ff))
* **pipeline:** optimize CI with molecule-action and ansible-lint action ([49f73ba](https://github.com/TheoPoc/laptop_setup/commit/49f73ba117c2b9c1fa6ae14ef88895761eba0905))
* **pipeline:** replace manual yamllint with ibiqlik/action-yamllint action ([4fcf75a](https://github.com/TheoPoc/laptop_setup/commit/4fcf75afeb0a80a919407ae972536d1e232c030e))
* **pipeline:** use action-ansible-playbook for syntax validation ([d1c9025](https://github.com/TheoPoc/laptop_setup/commit/d1c90250ace3afdf2c897fc3908238a5c6dd9cb7))
* **test:** enable debug mode for molecule tests in CI pipeline ([19a582c](https://github.com/TheoPoc/laptop_setup/commit/19a582c8b3c07d9705e9610a30462acd6cbdedac))

### 🔧 Chores

* **deps:** Update npm dependencies ([#24](https://github.com/TheoPoc/laptop_setup/issues/24)) ([05f650a](https://github.com/TheoPoc/laptop_setup/commit/05f650a66600ee6208f464a2eb67ce34c56a5858))

## [1.4.0](https://github.com/TheoPoc/laptop_setup/compare/v1.3.0...v1.4.0) (2025-11-09)

### ✨ Features

* **ci:** enhance Telegram notification with release tag and commit message ([362985e](https://github.com/TheoPoc/laptop_setup/commit/362985e43140a4d44f208177754072f08a6622b4))

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
