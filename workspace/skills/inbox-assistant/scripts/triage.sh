#!/usr/bin/env bash
# Print every unread message in INBOX, newest first, with full bodies.
set -euo pipefail

ids=$(himalaya envelope list --folder INBOX --page-size 50 --output json not flag seen \
  | jq -r '.[].id')

for id in $ids; do
  echo "===== message $id ====="
  himalaya message read "$id" --preview
  echo
done
