#!/usr/bin/env bash
#
# release.sh — cut a chat_bubbles release end-to-end.
#
# Usage:   ./scripts/release.sh <X.Y.Z>
# Example: ./scripts/release.sh 1.10.1
#
# Preconditions (the script verifies and aborts if any fail):
#   - run from repo root
#   - working tree clean
#   - CHANGELOG.md already has a "## [X.Y.Z] - DD/MM/YYYY" section at the top
#   - dart analyze lib/ produces 0 issues
#
# Side effects on success:
#   - updates version in pubspec.yaml and the install snippet in README.md
#   - cleans build artifacts
#   - runs `flutter pub publish --dry-run`
#   - PROMPTS before running `flutter pub publish`
#   - PROMPTS before creating + pushing the git tag

set -euo pipefail

red()    { printf '\033[31m%s\033[0m\n' "$*" >&2; }
green()  { printf '\033[32m%s\033[0m\n' "$*"; }
yellow() { printf '\033[33m%s\033[0m\n' "$*"; }
step()   { printf '\n\033[1m==> %s\033[0m\n' "$*"; }

abort() { red "ERROR: $*"; exit 1; }

# --- args ---------------------------------------------------------------------

[[ $# -eq 1 ]] || abort "Usage: $0 <X.Y.Z>"
VERSION="$1"
[[ "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || abort "Version must be semver X.Y.Z (got: $VERSION)"

# --- preconditions ------------------------------------------------------------

step "Verifying preconditions"

[[ -f pubspec.yaml && -f CHANGELOG.md && -f README.md ]] \
  || abort "Run from repo root (pubspec.yaml not found here)."

[[ -z "$(git status --porcelain)" ]] \
  || abort "Working tree dirty. Commit or stash first."

grep -q "^## \[$VERSION\] - " CHANGELOG.md \
  || abort "CHANGELOG.md has no '## [$VERSION] - DD/MM/YYYY' entry. Add one first."

# --- bump version in pubspec.yaml + README.md --------------------------------

step "Bumping pubspec.yaml + README.md to $VERSION"

CURRENT="$(grep '^version:' pubspec.yaml | awk '{print $2}')"
if [[ "$CURRENT" == "$VERSION" ]]; then
  yellow "pubspec.yaml already at $VERSION — skipping bump."
else
  # macOS sed needs '' after -i
  sed -i '' "s/^version: .*/version: $VERSION/" pubspec.yaml
  sed -i '' "s/  chat_bubbles: \^[0-9]\+\.[0-9]\+\.[0-9]\+/  chat_bubbles: ^$VERSION/" README.md
  green "Bumped from $CURRENT → $VERSION."
fi

# --- clean build artifacts ----------------------------------------------------

step "Cleaning build artifacts"

(cd example && flutter clean > /dev/null) || true
rm -rf .dart_tool build
find . -name ".DS_Store" -delete 2>/dev/null || true
green "Clean."

# --- static analysis ----------------------------------------------------------

step "Running dart analyze lib/"

if ! dart analyze lib/; then
  abort "dart analyze reported issues. Fix before releasing."
fi
green "Analyzer clean."

# --- commit if there are bump changes ----------------------------------------

if [[ -n "$(git status --porcelain pubspec.yaml README.md)" ]]; then
  step "Committing version bump"
  git add pubspec.yaml README.md
  # CHANGELOG is assumed to already be committed; if it's still dirty, the
  # earlier "working tree dirty" check would have failed.
  git commit -m "v$VERSION"
  green "Committed v$VERSION on $(git branch --show-current)."
fi

# --- dry-run publish ---------------------------------------------------------

step "Running flutter pub publish --dry-run"
flutter pub publish --dry-run

# --- confirm + publish -------------------------------------------------------

echo
yellow "About to PUBLISH chat_bubbles $VERSION to pub.dev."
read -r -p "Type the version to confirm: " CONFIRM
[[ "$CONFIRM" == "$VERSION" ]] || abort "Confirmation mismatch. Aborted."

step "Publishing to pub.dev"
flutter pub publish

# --- tag ---------------------------------------------------------------------

echo
read -r -p "Create + push tag v$VERSION? [y/N] " TAG_OK
if [[ "$TAG_OK" == "y" || "$TAG_OK" == "Y" ]]; then
  git tag -a "v$VERSION" -m "v$VERSION"
  git push origin "v$VERSION"
  green "Tag v$VERSION pushed."
else
  yellow "Skipped tagging. Remember to tag from master:  git tag -a v$VERSION -m v$VERSION && git push origin v$VERSION"
fi

green "Done. v$VERSION is live."
