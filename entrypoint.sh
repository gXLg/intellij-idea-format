#!/bin/bash

git config --global --add safe.directory /github/workspace
cd /github/workspace

IDEA_DIR=".idea-cache"
mkdir -p "$IDEA_DIR"

if [[ ! -d "$IDEA_DIR/bin" ]]; then
  echo "Download IntelliJ IDEA..."
  wget --no-verbose -O /tmp/idea.tar.gz "https://download.jetbrains.com/idea/ideaIC-2025.2.6.tar.gz"
  tar xzf /tmp/idea.tar.gz -C "$IDEA_DIR" --strip-components=1
  rm /tmp/idea.tar.gz
fi

version=$("$IDEA_DIR/bin/idea.sh" --version 2>/dev/null || true)
echo "Running:"
echo "$version"
echo "Formatting..."
"$IDEA_DIR/bin/format.sh" -m "./src/**/*.java" -s "./style/IntelliJ IDEA.xml" -r .

echo "Finished"
git --no-pager diff --exit-code
