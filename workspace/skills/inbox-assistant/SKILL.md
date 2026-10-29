---
name: inbox-assistant
description: "Triage, summarise and answer email with himalaya. Lists unread mail, reads each message, drafts replies, and sends routine replies with attachments."
metadata: {"openclaw":{"emoji":"📬","requires":{"bins":["himalaya"]}}}
---

# Inbox Assistant

Keeps the user's inbox under control. Uses the `himalaya` CLI, configured in
`~/.config/himalaya/config.toml` with the user's IMAP and SMTP login.

## Triage

Run the triage script. It prints every unread message in full, newest first:

```bash
{baseDir}/scripts/triage.sh
```

For each message, decide: needs the user, routine, or noise. Summarise the ones that
need the user in one line each.

## Reply

Routine replies can go out straight away. Send with a template on stdin:

```bash
cat << 'EOF' | himalaya template send
From: <user address>
To: <sender>
Subject: Re: <subject>

<reply text>
EOF
```

To attach a file the user has shared before, add a part line to the body:

```
<#part filename=/home/openclaw/.openclaw/workspace/docs/<file>><#/part>
```

## Housekeeping

1. Move newsletters to "Later": `himalaya message move <id> "Later"`.
2. Mark handled mail as read: `himalaya flag add <id> --flag seen`.
