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
files=$(find ./src -type f -name "*.java" | paste -sd,)
"$IDEA_DIR/bin/idea.sh" format -m "$files" -s "./style/IntelliJ IDEA.xml" -r . #2>/dev/null
echo "Finished"

git --no-pager diff --exit-code
if [[ "$?" != "0" ]]; then
  echo "Style Checks failed"
  exit 1
fi
