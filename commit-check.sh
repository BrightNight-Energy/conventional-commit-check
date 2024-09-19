#!/bin/bash

echo "Running conventional commit check" >&2
echo "Branch: $(git rev-parse --abbrev-ref HEAD)" >&2

# Get the current branch name
branch_name=$(git rev-parse --abbrev-ref HEAD)

# Check the number of commits on this branch that are not on the main branch
commit_count=$(git rev-list --count main..$branch_name)
echo "Commit count relative to main: $commit_count" >&2

# Only check the commit message if it's the first commit on this branch
if [ "$commit_count" -eq 0 ] || [ "$commit_count" -eq 1 ]; then
  commit_msg=$(git log -1 --pretty=%B)
  echo "Commit message: $commit_msg" >&2

  # Define a regex pattern for conventional commit messages
  pattern="^(feat|fix|docs|style|refactor|test|chore|revert|build|ci|perf|other)(\([a-zA-Z0-9_\-]+\))?: .+"

  # Check if the commit message matches the pattern
  if ! echo "$commit_msg" | grep -Eq "$pattern"; then
    echo "Error: The commit message does not follow the conventional commit pattern." >&2
    exit 1
  fi
else
  echo "Not the first commit, skipping check." >&2
fi

exit 1