#!/bin/bash

#!/bin/bash

# Define an array of emoji patterns
emojis=(
    "⚗️|:alembic:"
    "👽️|:alien:"
    "🚑️|:ambulance:"
    "🎨|:art:"
    "🩹|:adhesive_bandage:"
    "⬇️|:arrow_down:"
    "⬆️|:arrow_up:"
    "🍱|:bento:"
    "💥|:boom:"
    "📦️|:package:"
    "🔖|:bookmark:"
    "👷|:construction_worker:"
    "🏗️|:building_construction:"
    "🍻|:beers:"
    "🧱|:bricks:"
    "💡|:bulb:"
    "🔊|:loud_sound:"
    "🔇|:mute:"
    "🗃️|:card_file_box:"
    "📸|:camera_flash:"
    "♿️|:wheelchair:"
    "🔐|:closed_lock_with_key:"
    "🤡|:clown_face:"
    "🚧|:construction:"
    "🔀|:twisted_rightwards_arrows:"
    "🎉|:tada:"
    "📄|:page_facing_up:"
    "🔨|:hammer:"
    "💄|:lipstick:"
    "🔒️|:lock:"
    "🔍️|:mag:"
    "📈|:chart_with_upwards_trend:"
    "🧑‍💻|:technologist:"
    "📝|:memo:"
    "🔧|:wrench:"
    "🐛|:bug:"
    "👥|:busts_in_silhouette:"
    "🚸|:children_crossing:"
    "🚚|:truck:"
    "🌱|:seedling:"
    "🛂|:passport_control:"
    "💚|:green_heart:"
    "🚩|:triangular_flag_on_post:"
    "⚡️|:zap:"
    "🔥|:fire:"
    "🏷️|:label:"
    "💬|:speech_balloon:"
    "📱|:iphone:"
    "🧪|:test_tube:"
    "🥅|:goal_net:"
    "🎨|:art:"
    "🍻|:beers:"
    "🍱|:bento:"
    "🛂|:passport_control:"
)

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

echo "$commit_msg"

# Only check the commit message if it's the first commit on this branch
if [ "$commit_count" -eq 0 ]; then
  # Define regex patterns based on parser
  if [[ "$parser" == "emoji" ]]; then
    emoji_pattern=$(IFS="|"; echo "${emojis[*]}")

    # Add the start (^) and non-capturing group (?: ... ) to form the regex pattern
    pattern="^(?:$emoji_pattern)"
  elif [[ "$parser" == "angular" ]]; then
    pattern="^(feat(\!)?|fix|docs|style|refactor|test|chore|revert|build|ci|perf|other)(\([a-zA-Z0-9_\-]+\))?: .+"
  else
    echo "Error: Invalid commit parser value"
    exit 1  # Exit with a non-zero status to indicate an error
  fi

  # Check if the commit message matches the pattern
  if ! echo "$commit_msg" | grep -Eq "$pattern"; then
    echo "Error: The first commit message on this branch does not follow the conventional commit pattern." >&2
    echo "Expected format: <type>(<optional scope>): <description>" >&2
    if [[ "$parser" == "emoji" ]]; then
      joined_emojis=$(IFS=", "; echo "${emojis[*]}")
      echo "Where <type> is one of these emojis=$joined_emojis" >&2
      echo "It is recommend to use gitmoji-cli (npm install -g gitmoji-cli). For more information, see: https://gitmoji.dev" >&2
    else
      echo "Where <type> is one of feat, feat!, fix, docs, style, refactor, test, chore, revert, build, ci, perf, other" >&2
    fi
    exit 1
  fi
else
  echo "Not the first commit, skipping check."
fi

exit 0
