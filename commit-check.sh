#!/bin/bash

# Get the current branch name
branch_name=$(git rev-parse --abbrev-ref HEAD)

# Check the number of commits on this branch that are not on the main branch
commit_count=$(git rev-list --count main..$branch_name)
# Only check the commit message if it's the first commit on this branch

if [ "$commit_count" -eq 0 ]; then
  # Get the commit message of the staged commit
  commit_msg_file="$1"

  # Read the commit message from the file
  commit_msg=$(cat "$commit_msg_file")
  # Define a regex pattern for conventional commit messages
  pattern="^(feat(\!)?|fix|docs|style|refactor|test|chore|revert|build|ci|perf|other)(\([a-zA-Z0-9_\-]+\))?: .+"
  # Check if the commit message matches the pattern
  if ! echo "$commit_msg" | grep -Eq "$pattern"; then
    echo "Error: The first commit message on this branch does not follow the conventional commit pattern." >&2
    echo "Expected format: <type>(<optional scope>): <description>" >&2
    echo "Where <type> is one of feat, fix, docs, style, refactor, test, chore, revert, build, ci, perf, other" >&2
    exit 1
  fi
fi

# Allow the commit if all checks pass
exit 0