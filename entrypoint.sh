#!/bin/bash

if [[ $# -ne 1 ]]; then
  echo "Exactly one parameter required: idea-url"
  exit 1
fi

IDEA_URL=$1
IDEA_DIR="/github/workflow/idea-cache"
mkdir -p "$IDEA_DIR"

if [[ ! -d "$IDEA_DIR/bin" ]]; then
  echo "Download IntelliJ IDEA..."
  wget --no-verbose -O /tmp/idea.tar.gz "$IDEA_URL"
  tar xzf /tmp/idea.tar.gz -C "$IDEA_DIR" --strip-components=1
  rm /tmp/idea.tar.gz
fi

version=$("$IDEA_DIR/bin/idea.sh" --version 2>/dev/null || true)
echo "Running:"
echo "$version"
echo "Formatting..."
"$IDEA_DIR/bin/format.sh" -m "./src/**/*.java" -s "./style/IntelliJ IDEA.xml" -r . >/dev/null 2>&1 || true

echo "Finished"
git --no-pager diff --exit-code
