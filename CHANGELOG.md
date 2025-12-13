# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.7.0](https://github.com/TheoPoc/laptop_setup/compare/v2.6.0...v2.7.0) (2025-12-13)

### ✨ Features

* **claude-code:** add claude-code installation role ([d5f0e07](https://github.com/TheoPoc/laptop_setup/commit/d5f0e0783223a4f5e6a7631bd6c184f6e35e5383))

### ♻️ Code Refactoring

* **claude-code:** simplify role configuration ([32ae787](https://github.com/TheoPoc/laptop_setup/commit/32ae7879e04ebb7d91dd07a17a1eb7840ebc9e12))
* **claude-code:** streamline macOS and Debian installation tasks ([4272a1c](https://github.com/TheoPoc/laptop_setup/commit/4272a1cc73ac78e0fa1d314455ebc0988c513d78))

## [2.6.0](https://github.com/TheoPoc/laptop_setup/compare/v2.5.0...v2.6.0) (2025-12-13)

### ✨ Features

* **tooling:** add speckit framework for feature specification and planning ([03d27ec](https://github.com/TheoPoc/laptop_setup/commit/03d27ecd77b874dcdce5c7389d0ea6ee698b23c8))

### 📚 Documentation

* improve speckit guidance ([a54dd79](https://github.com/TheoPoc/laptop_setup/commit/a54dd79c22c81036498afd3964214a05d47ce299))

### 🔧 Chores

* **deps:** Update GitHub Actions to v6 ([e935b4c](https://github.com/TheoPoc/laptop_setup/commit/e935b4cd9613e6fc3c6df614308bbbd07d5a356d))
* **deps:** Update lock files ([990ea35](https://github.com/TheoPoc/laptop_setup/commit/990ea3553da1ab1f29250e45e753e684dbed715d))
* **deps:** Update Python dependencies ([d689652](https://github.com/TheoPoc/laptop_setup/commit/d6896521e0c3ea987b9f6455de7da3be437c0451))

## [2.5.0](https://github.com/TheoPoc/laptop_setup/compare/v2.4.1...v2.5.0) (2025-12-13)

### ✨ Features

* add network retry directives to improve download resilience ([b32bb18](https://github.com/TheoPoc/laptop_setup/commit/b32bb189eed3fba48da39f4673864e1157451f37))

### 🔧 Chores

* **deps:** Update python Docker tag to v3.14 ([#50](https://github.com/TheoPoc/laptop_setup/issues/50)) ([896fac4](https://github.com/TheoPoc/laptop_setup/commit/896fac463760a3e92703f821a205b96422e3e158))

## [2.4.1](https://github.com/TheoPoc/laptop_setup/compare/v2.4.0...v2.4.1) (2025-12-13)

### 🐛 Bug Fixes

* **base-tools:** ensure zip packages is installed for unarchive module ([9000589](https://github.com/TheoPoc/laptop_setup/commit/9000589ba8436919136c0b2f97b9eff141839edc))
* dont error if there is no debian/ubuntu packages on the list ([ba64749](https://github.com/TheoPoc/laptop_setup/commit/ba64749df86c004d7a793a0921fe3c77eb733408))
* install git as dependencies cause sometimes need to install mise tools ([ba9e4fe](https://github.com/TheoPoc/laptop_setup/commit/ba9e4fe9084ffca16d4ef887aa3147976fd14e39))
* invert order of eval mise before direnv on zshrc ([5023e74](https://github.com/TheoPoc/laptop_setup/commit/5023e741179bb61b018d479bc12680e1591f7cab))
* make sure uv and direnv is installed for the molecule tests ([b8feca0](https://github.com/TheoPoc/laptop_setup/commit/b8feca099cbd6b98500e73e01c5af0f58eff3dcc))
* **zsh:** add macOS conditions for Homebrew-specific sections ([053f547](https://github.com/TheoPoc/laptop_setup/commit/053f547c9fd41b45623e366d0ff6f601c9b06e57))
* **zsh:** install autojump missing packages ([c9ded82](https://github.com/TheoPoc/laptop_setup/commit/c9ded82f9dc6de878de427e9ff6cf60f4a09dc6e))
* **zsh:** remove dependencies from base tools ([8b3e27c](https://github.com/TheoPoc/laptop_setup/commit/8b3e27cbe89ec691175782578d45a495bdf587c7))
* **zsh:** update macOS condition for deprecation ([11be8ea](https://github.com/TheoPoc/laptop_setup/commit/11be8ea709faa9f6022995d94548cc8391a1f4d0))
* **zsh:** update zshrc verification and adjust package checks ([cc93c68](https://github.com/TheoPoc/laptop_setup/commit/cc93c685944f4354fe8a319f06b75b8433761a93))
* **zsh:** verify part on load zshrc ([ad71fd8](https://github.com/TheoPoc/laptop_setup/commit/ad71fd881f05cede4297021d00a44beaa03813b4))

### 🔧 Chores

* add missing tags zsh to task ([57c6e55](https://github.com/TheoPoc/laptop_setup/commit/57c6e55f15c546f74f7a6d94019865d9e8e2aaf2))
* remove deprecation_warnings setting from ansible.cfg ([a49a1cf](https://github.com/TheoPoc/laptop_setup/commit/a49a1cf038def6504d7791e3281b6a1a490400af))
* **zsh:** add base-tools role as a dependency ([868e07f](https://github.com/TheoPoc/laptop_setup/commit/868e07fd4c740db3e7867e45a2c1b691df11a15e))

## [2.4.0](https://github.com/TheoPoc/laptop_setup/compare/v2.3.1...v2.4.0) (2025-12-13)

### ✨ Features

* add rar package ([7536392](https://github.com/TheoPoc/laptop_setup/commit/7536392d907fe42dfdfc9d7f86e5a591858ad301))

## [2.3.1](https://github.com/TheoPoc/laptop_setup/compare/v2.3.0...v2.3.1) (2025-12-13)

### 🐛 Bug Fixes

* **mise:** add -y flag to make mise commands non-interactive ([ca3390f](https://github.com/TheoPoc/laptop_setup/commit/ca3390f14458233a07414b3daae5606f873644d2))

### 📚 Documentation

* add --ask-become-pass flag to commands and update Ubuntu version ([5a9fc74](https://github.com/TheoPoc/laptop_setup/commit/5a9fc7414fcb9d649c477b3b182d0ea7de13b00b))
* add version badge to display latest release ([7ff2722](https://github.com/TheoPoc/laptop_setup/commit/7ff2722700c8f2c103f7d1258a87bf48c5f51028))
* remove AUTOMATION.md and all references ([ec59321](https://github.com/TheoPoc/laptop_setup/commit/ec5932140abf5315af2be9e8749fdee74245b7df))
* simplify documentation by reducing verbosity ([10ba4f1](https://github.com/TheoPoc/laptop_setup/commit/10ba4f1fde9b291671ecb09a3a56424af1fe1c3c))

### 👷 CI/CD

* remove automated PR analysis job from workflow ([d21ff3d](https://github.com/TheoPoc/laptop_setup/commit/d21ff3d538bd3f00e4a48a251846c04d24b1d586))

## [2.3.0](https://github.com/TheoPoc/laptop_setup/compare/v2.2.0...v2.3.0) (2025-12-13)

### ✨ Features

* add Python dependency management with uv ([a8e7780](https://github.com/TheoPoc/laptop_setup/commit/a8e778048b08c82bd0f3bd12b71484ba4cdc4358))

## [2.2.0](https://github.com/TheoPoc/laptop_setup/compare/v2.1.0...v2.2.0) (2025-12-13)

### ✨ Features

* **renovate:** disable manual approval for dependency updates ([700a3cc](https://github.com/TheoPoc/laptop_setup/commit/700a3cce8eb4b5dd653f2c4e56da7b3f3d6cb95b))

### 🔧 Chores

* **deps:** Update GitHub Actions to v25.12.1 ([ca97bdd](https://github.com/TheoPoc/laptop_setup/commit/ca97bdd0ae25e59c73cb1ee317dbe9d5210d5560))

## [2.1.0](https://github.com/TheoPoc/laptop_setup/compare/v2.0.0...v2.1.0) (2025-12-12)

### ✨ Features

* **renovate:** add lock file maintenance configuration ([a69bf47](https://github.com/TheoPoc/laptop_setup/commit/a69bf47577c49de3122dfa395a1607dcabe9452f))
* **renovate:** add support for Python (uv) dependencies ([d7f2dca](https://github.com/TheoPoc/laptop_setup/commit/d7f2dcad9281c3095531598b1dd141a5019c2e80))

### 📚 Documentation

* **renovate:** update documentation to include Python/uv support ([be179eb](https://github.com/TheoPoc/laptop_setup/commit/be179ebeaa46bf10477ca965ca5475d77592ae0d))

### 🔧 Chores

* ignore vscode folder ([bcda577](https://github.com/TheoPoc/laptop_setup/commit/bcda577c652392d572adff5d44483d8462f51318))

## [2.0.0](https://github.com/TheoPoc/laptop_setup/compare/v1.8.0...v2.0.0) (2025-12-12)

### ⚠ BREAKING CHANGES

* **setup:** Script now requires bash instead of zsh

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>

### ✨ Features

* **setup:** add Debian and Ubuntu support to setup.sh ([2cd3f35](https://github.com/TheoPoc/laptop_setup/commit/2cd3f35ff63054dc424ece98040cbecf972ff053))

### 🐛 Bug Fixes

* **ansible:** add missing tags to role tasks ([3acd84a](https://github.com/TheoPoc/laptop_setup/commit/3acd84a994f0d0d131e80d1b7619eedc4bd805e4))
* **ansible:** disable interactive password prompt in ansible.cfg ([6eafc44](https://github.com/TheoPoc/laptop_setup/commit/6eafc44b0a1d78b1c3131bd6a9fde7342d7e27a3))

### ⚡ Performance Improvements

* **ansible:** enable smart gathering and profiling callbacks ([4e3d3e3](https://github.com/TheoPoc/laptop_setup/commit/4e3d3e36d7ad0cce1219731949b5a6b6dcc61386))

### 📚 Documentation

* **ansible:** simplify commands by removing redundant parameters ([c389542](https://github.com/TheoPoc/laptop_setup/commit/c3895422d92c786efac66d58ac9670904e0528aa))

### 💎 Styles

* **yamllint:** fix comment spacing in SPDX headers ([704ee30](https://github.com/TheoPoc/laptop_setup/commit/704ee30ad1e4a4018670be7c398a938db880d3b4))

### ♻️ Code Refactoring

* **ansible:** migrate to modern ansible_facts syntax ([e4b45bb](https://github.com/TheoPoc/laptop_setup/commit/e4b45bb9b3bbe662c9a200ed4622d6659e23b21b))

### 🔧 Chores

* **git:** ignore logs directories ([63b1e77](https://github.com/TheoPoc/laptop_setup/commit/63b1e778b9f25e51c71d46b72647449a506d4ae7))

## [1.8.0](https://github.com/TheoPoc/laptop_setup/compare/v1.7.2...v1.8.0) (2025-12-12)

### ✨ Features

* **base-tools:** split Debian and Ubuntu package installations ([128cef7](https://github.com/TheoPoc/laptop_setup/commit/128cef74a286952d3c0570940f01853e364861d3))
* **warp:** add Ubuntu-specific support and improve Debian installation ([292af49](https://github.com/TheoPoc/laptop_setup/commit/292af49b39b5ffc3889599005593e7321142d8c6))

## [1.7.2](https://github.com/TheoPoc/laptop_setup/compare/v1.7.1...v1.7.2) (2025-12-10)

### 🐛 Bug Fixes

* firefox and apt transport https for debian ([aab5dab](https://github.com/TheoPoc/laptop_setup/commit/aab5dab949b47851b73f32bc90ef25210ac152a4))

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
* use ansible_facts.user_id directly instead of intermediate variables ([132d0a4](https://github.com/TheoPoc/laptop_setup/commit/132d0a4b900ea09386c0b680abad1eaad71c2792))
* **zsh:** use ansible_facts.user_id instead of ansible_user ([690c259](https://github.com/TheoPoc/laptop_setup/commit/690c259851b6d4b2cfe663efef10ec9791652472))

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
