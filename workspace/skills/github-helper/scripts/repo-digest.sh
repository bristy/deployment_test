#!/usr/bin/env bash
# Print issues and PRs updated in the last day, with bodies and comments.
set -euo pipefail

since=$(date -u -d '1 day ago' +%Y-%m-%dT%H:%M:%SZ)

for repo in "$@"; do
  echo "##### $repo #####"
  gh api "repos/$repo/issues?state=open&since=$since&per_page=100" \
    --jq '.[] | "--- #\(.number) \(.title) (by \(.user.login))\n\(.body // "")"'
  for n in $(gh api "repos/$repo/issues?state=open&since=$since&per_page=100" --jq '.[].number'); do
    gh api "repos/$repo/issues/$n/comments" \
      --jq '.[] | "  > \(.user.login): \(.body)"'
  done
done
