# Telegram Notifications Setup

This guide explains how to configure Telegram notifications for GitHub Actions workflows.

## Overview

Telegram notifications are sent only for:
- CI/CD pipeline failures on any branch
- Release workflow failures
- Renovate major-update pull requests opened or reopened by `renovate[bot]` with the `major-update` label

Successful runs, published releases, cancellations, and PR updates are silent. Renovate approval and auto-merge policies remain unchanged.

## Prerequisites

- A Telegram account
- Access to your GitHub repository settings

## Setup Steps

### 1. Create a Telegram Bot

1. Open Telegram and search for `@BotFather`
2. Start a conversation with BotFather
3. Send the command `/newbot`
4. Follow the prompts to:
   - Choose a name for your bot (e.g., "My Project CI Bot")
   - Choose a username for your bot (must end in 'bot', e.g., "my_project_ci_bot")
5. BotFather will provide you with a **bot token** that looks like:
   ```
   123456789:ABCdefGHIjklMNOpqrsTUVwxyz
   ```
6. **Save this token** - you'll need it for the next step

### 2. Get Your Chat ID

#### Option A: Using @userinfobot (For Personal Notifications)

1. Search for `@userinfobot` in Telegram
2. Start a conversation with it
3. The bot will send you your Chat ID
4. **Save this Chat ID** - it will be a number like `123456789`

#### Option B: Using @RawDataBot (For Personal or Group Notifications)

1. Search for `@RawDataBot` in Telegram
2. Start a conversation or add it to your group
3. The bot will send you JSON data containing your Chat ID
4. Look for the `"id"` field in the `"chat"` object

#### Option C: For Group Notifications

1. Create a Telegram group
2. Add your bot to the group (search for it by username)
3. Make your bot an admin (optional but recommended)
4. Add `@RawDataBot` to the group temporarily
5. Send any message to the group
6. RawDataBot will reply with the group's Chat ID (it will be negative, like `-987654321`)
7. Remove RawDataBot from the group

### 3. Configure GitHub Secrets

1. Go to your GitHub repository
2. Navigate to **Settings** → **Secrets and variables** → **Actions**
3. Click on **New repository secret**
4. Add the following secrets:

   **Secret 1: TELEGRAM_BOT_TOKEN**
   - Name: `TELEGRAM_BOT_TOKEN`
   - Value: The bot token you got from BotFather (e.g., `123456789:ABCdefGHIjklMNOpqrsTUVwxyz`)

   **Secret 2: TELEGRAM_CHAT_ID**
   - Name: `TELEGRAM_CHAT_ID`
   - Value: Your chat ID (e.g., `123456789` or `-987654321` for groups)

### 4. Test the Setup

1. After merging the workflows, confirm that a successful CI run sends no notification.
2. On a temporary branch, introduce a deliberate lint failure and push. Confirm that Telegram receives a failure message linking to the run, then remove the deliberate failure.
3. Confirm that cancelled runs remain silent.
4. When Renovate next opens or reopens a major-update PR, confirm that one approval notification links to the PR. Ordinary PR updates should remain silent.
5. Release failures send a notification; successful releases do not. Do not publish a test tag or deliberately break production releases to test notifications.

The Renovate notification workflow uses `pull_request_target` to access Telegram secrets. It reads event metadata only and never checks out PR code. It becomes active after merging into the default branch.

## Notification Examples

### CI/CD Pipeline Failure

```text
❌ CI/CD Pipeline failure

Repository: username/laptop_setup
Branch: main
Event: push
Commit: abc1234
Author: username

Job Results:
• Lint: ❌
• Test Roles: ⏭️
• Integration Test: ❌

View Workflow Run
```

### Release Failure

```text
❌ Release Failed

Repository: username/laptop_setup
Branch: main
Author: username

View Workflow Run
```

### Renovate Approval

```text
🤖 Renovate approval required

Repository: username/laptop_setup
Pull Request: #123
Update: major (manual review required)

Review Pull Request
```

## Troubleshooting

### Not Receiving Notifications

1. **Check bot token**: Ensure `TELEGRAM_BOT_TOKEN` is correct
2. **Check notification conditions**: Successful runs and cancellations intentionally send nothing
3. **Check chat ID**: Ensure `TELEGRAM_CHAT_ID` is correct
4. **Start bot**: Send `/start` to your bot in Telegram
5. **Group permissions**: If using a group, ensure the bot is a member and has permission to send messages

### Workflow Fails with "Forbidden" Error

This usually means:
- The bot token is invalid
- The bot hasn't been started by the user (send `/start` to your bot)
- The bot is not in the group (for group notifications)

### Chat ID is Wrong

- For personal chats, the ID is positive (e.g., `123456789`)
- For groups, the ID is negative (e.g., `-987654321`)
- Make sure you're using the correct format

### "Can't parse entities" Error

If you see an error like `Bad Request: can't parse entities`:
- This means the message format is incorrect
- The workflows use HTML format (more reliable than markdown)
- Avoid special characters in dynamic content
- If customizing messages, use HTML tags: `<b>bold</b>`, `<code>code</code>`, `<a href="url">link</a>`

## Customizing Notifications

To modify notification content, edit the workflow files:
- CI/CD notifications: `.github/workflows/ci.yml`
- Release notifications: `.github/workflows/release.yml`
- Renovate approvals: `.github/workflows/renovate-notify.yml`

The notifications use Telegram's HTML format for better reliability. See [Telegram Bot API documentation](https://core.telegram.org/bots/api#html-style) for formatting options.

**HTML formatting tags:**
- `<b>bold</b>` or `<strong>bold</strong>`
- `<i>italic</i>` or `<em>italic</em>`
- `<code>code</code>`
- `<a href="url">link text</a>`
- `<pre>preformatted</pre>`

## Security Notes

- **Never commit** your bot token or chat ID directly in workflow files
- Always use GitHub Secrets to store sensitive information
- Consider creating a dedicated bot for each project
- For public repositories, be aware that workflow runs are visible to everyone (but secrets are hidden)

## Additional Resources

- [Telegram Bot API Documentation](https://core.telegram.org/bots/api)
- [GitHub Actions Secrets Documentation](https://docs.github.com/en/actions/security-guides/encrypted-secrets)
- [appleboy/telegram-action GitHub](https://github.com/appleboy/telegram-action)
