#!/bin/bash

# The commit message file is passed as the first argument in commit-msg hooks
parser="angular"
commit_msg_file=""

# Argument parser to find commit message file and --parser option
for arg in "$@"
do
  if [[ -f "$arg" ]]; then
    # If $arg is a valid file, treat it as the commit message file
    commit_msg_file="$arg"
  elif [[ "$arg" == --parser=* ]]; then
    # If $arg is the --parser option, extract the value
    parser="${arg#*=}"
  fi
done

# Ensure that we have found the commit message file
if [[ -z "$commit_msg_file" ]]; then
  echo "Error: Could not find the commit message file." >&2
  exit 1
fi

# Read the commit message from the file
commit_msg=$(cat "$commit_msg_file")

# Get the current branch name
branch_name=$(git rev-parse --abbrev-ref HEAD)

# Check the number of commits on this branch that are not on the main branch
commit_count=$(git rev-list --count main..$branch_name)
echo "Commit count relative to main: $commit_count" >&2

# Only check the commit message if it's the first commit on this branch
if [ "$commit_count" -eq 0 ]; then
  # Define regex patterns based on parser
  if [[ "$parser" == "emoji" ]]; then
    pattern="^(?::boom:|:sparkles:|:children_crossing:|:lipstick:|:iphone:|:egg:|:chart_with_upwards_trend:|:ambulance:|:lock:|:bug:|:zap:|:goal_net:|:alien:|:wheelchair:|:speech_balloon:|:mag:|:apple:|:penguin:|:checkered_flag:|:robot:|:green_apple:)"
  elif [[ "$parser" == "angular" ]]; then
    pattern="^(feat(\!)?|fix|docs|style|refactor|test|chore|revert|build|ci|perf|other)(\([a-zA-Z0-9_\-]+\))?: .+"
  else
    echo "Error: Invalid commit parser value"
    exit 1  # Exit with a non-zero status to indicate an error
  fi

  # Print the selected pattern
  echo "Selected pattern: $pattern"

  # Check if the commit message matches the pattern
  if ! echo "$commit_msg" | grep -Eq "$pattern"; then
    echo "Error: The first commit message on this branch does not follow the conventional commit pattern." >&2
    echo "Expected format: <type>(<optional scope>): <description>" >&2
    if [[ "$parser" == "emoji" ]]; then
      echo "Where <type> is one of emoji_patterns=:boom:, :sparkles:, :children_crossing:, :lipstick:, :iphone:, :egg:, :chart_with_upwards_trend:, :ambulance:, :lock:, :bug:, :zap:, :goal_net:, :alien:, :wheelchair:, :speech_balloon:, :mag:, :apple:, :penguin:, :checkered_flag:, :robot:, :green_apple:" >&2
      echo "For more information, see: https://gitmoji.dev" >&2
    else
      echo "Where <type> is one of feat, feat!, fix, docs, style, refactor, test, chore, revert, build, ci, perf, other" >&2
    fi
    exit 1
  fi
else
  echo "Not the first commit, skipping check."
fi

exit 0
