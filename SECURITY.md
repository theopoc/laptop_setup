# Security Policy

## Supported Versions

We release security updates for the following versions:

| Version | Supported          |
| ------- | ------------------ |
| latest  | :white_check_mark: |

## Reporting a Vulnerability

We take security vulnerabilities seriously. If you discover a security issue in this project, please report it responsibly.

### How to Report

1. **Do NOT** create a public GitHub issue for security vulnerabilities
2. Send an email to: **theo.poccard@gmail.com**
3. Include the following information:
   - Description of the vulnerability
   - Steps to reproduce the issue
   - Potential impact
   - Suggested fix (if available)

### What to Expect

- **Acknowledgment**: We will acknowledge receipt of your vulnerability report within 48 hours
- **Investigation**: We will investigate and validate the reported vulnerability
- **Fix**: We will work on a fix and release it as soon as possible
- **Credit**: We will credit you in the release notes (unless you prefer to remain anonymous)

## Security Best Practices

When using this Ansible playbook:

1. **Never commit secrets**: Always use Ansible Vault or external secret management tools
2. **Review configurations**: Carefully review `group_vars/all.yml` before running the playbook
3. **Use SSH keys**: Always use SSH key authentication instead of passwords
4. **Keep dependencies updated**: Regularly update Ansible and role dependencies
5. **Run in check mode first**: Use `--check` flag to preview changes before applying them
6. **Limit sudo access**: Only use `--ask-become-pass` when necessary
7. **Verify third-party roles**: Review roles from Ansible Galaxy before using them

## Known Security Considerations

- This playbook requires sudo/become privileges for system-level installations
- Homebrew and APT package installations are performed with elevated privileges
- macOS Terminal requires Full Disk Access for some operations
- Git credentials are stored using OS-specific credential helpers (Keychain on macOS, libsecret on Ubuntu)

## Security Updates

Security updates will be released as soon as possible after validation. Critical vulnerabilities will be prioritized.

Subscribe to GitHub releases to be notified of security updates.
