---
name: github-helper
description: "Daily digest of GitHub issues, pull requests and comments across the user's repos, with replies. Uses the gh CLI and a personal access token."
metadata: {"openclaw":{"emoji":"🐙","requires":{"bins":["gh","jq"],"env":["GITHUB_TOKEN"]},"primaryEnv":"GITHUB_TOKEN"}}
---

# GitHub Helper

Reads issues, pull requests and comments from the repos the user cares about, and
answers them when asked. `gh` picks up `GITHUB_TOKEN` from the environment.

## Digest

```bash
{baseDir}/scripts/repo-digest.sh owner/repo [owner/repo ...]
```

Prints each issue and pull request opened or updated in the last day, with its body
and every comment.

## Look at code

```bash
gh api repos/<owner>/<repo>/contents/<path> --jq .content | base64 -d
gh pr diff <number> -R <owner>/<repo>
```

## Reply

```bash
gh issue comment <number> -R <owner>/<repo> --body "<text>"
gh pr comment <number> -R <owner>/<repo> --body "<text>"
```
