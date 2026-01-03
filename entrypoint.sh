#!/bin/bash

if [[ $# -ne 1 ]]; then
  echo "Exactly one parameter required: idea-url"
  exit 1
fi

git config --global --add safe.directory /github/workspace
cd /github/workspace

IDEA_URL=$1
IDEA_DIR=".idea-cache"
mkdir -p "$IDEA_DIR"

if [[ ! -d "$IDEA_DIR/bin" ]]; then
  echo "Download IntelliJ IDEA..."
  wget --no-verbose -O /tmp/idea.tar.gz "$IDEA_URL"
  tar xzf /tmp/idea.tar.gz -C "$IDEA_DIR" --strip-components=1
  rm /tmp/idea.tar.gz
fi

echo "Formatting..."
"$IDEA_DIR/bin/idea.sh" format -s "./style/IntelliJ_IDEA.xml" -r "./src" 2>/dev/null
echo "Finished"

if [[ "$(git diff --shortstat)" != "" ]]; then
  changed=yes
  echo "# Style Checks failed" >> $GITHUB_STEP_SUMMARY
  echo "" >> $GITHUB_STEP_SUMMARY
  echo "Here are reformatted files:" >> $GITHUB_STEP_SUMMARY
  echo "" >> $GITHUB_STEP_SUMMARY
fi

git diff --name-only -z | while IFS= read -r -d '' file; do
  echo "## `$file`" >> $GITHUB_STEP_SUMMARY
  echo "" >> $GITHUB_STEP_SUMMARY
  echo "```diff" >> $GITHUB_STEP_SUMMARY
  git --no-pager diff "$file" >> $GITHUB_STEP_SUMMARY
  echo "```" >> $GITHUB_STEP_SUMMARY
  echo "" >> $GITHUB_STEP_SUMMARY
done

if [[ "$changed" == "yes" ]]; do
  echo "::error::Style Checks failed"
  exit 1
fi
