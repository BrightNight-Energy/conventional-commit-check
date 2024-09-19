#!/bin/bash

# Check if this is the first commit on the branch
branch_name=$(git rev-parse --abbrev-ref HEAD)
commit_count=$(git rev-list --count main..$branch_name)

if [ "$commit_count" -eq 0 ] || [ "$commit_count" -eq 1 ]; then
  commit_msg=$(git log -1 --pretty=%B)

  # Conventional commit pattern with optional scope
  pattern="^(feat|fix|docs|style|refactor|test|chore|revert|build|ci|perf|other)(\([a-zA-Z0-9_\-]+\))?: .+"

  if ! echo "$commit_msg" | grep -Eq "$pattern"; then
    echo "Error: The first commit message on this branch does not follow the conventional commit pattern." >&2
    echo "Expected format: <type>(<optional scope>): <description>" >&2
    echo "Where <type> is one of feat, fix, docs, style, refactor, test, chore, revert, build, ci, perf, other" >&2
    exit 1
  fi
fi

exit 0