# chat_bubbles

Flutter package providing chat-bubble widgets (WhatsApp-style and other shapes), a message bar, typing indicators, reactions, swipe actions, and message grouping helpers. Published on pub.dev as [`chat_bubbles`](https://pub.dev/packages/chat_bubbles).

> **Note for AI agents:** this file is the source of truth. `AGENTS.md` is a symlink to it for cross-tool compatibility (Cursor, Aider, Codex, Continue, Copilot Workspace).

## Common commands

Always run from the **repo root**, never from `example/`.

| What | Command |
|---|---|
| Analyze package (must be 0 issues before publish) | `dart analyze lib/` |
| Run widget tests | `flutter test` |
| Auto-fix lints (super-params, etc.) | `dart fix --apply lib/` |
| Resolve deps after pubspec edits | `flutter pub get` |
| Verify publish archive (~3 MB, 0 warnings) | `flutter pub publish --dry-run` |
| Cut a release end-to-end | `./scripts/release.sh <X.Y.Z>` |
| Run example app on web | `cd example && flutter run -d chrome` |

## Agent ground rules

- **Never `git push` to `master` directly.** Master is updated via PR from `develop` only.
- **Never run `flutter pub publish` without explicit user approval.** A release is a one-way action.
- **Never bump the major version without asking.** Major bumps drop users on older SDKs.
- **Never amend or force-push commits on a shared branch.** Local-only commits may be amended freely.
- **Always run `dart analyze lib/` before claiming a change is done.** A "0 issues" result is the bar for any code edit.
- **When adding a public class to `lib/`, you must also add an `export` line** to `lib/chat_bubbles.dart`. Forgetting this means consumers can't reach the class — caught at v1.10.0.
- **Use `Color.withValues(alpha: x)`, never `Color.withOpacity(x)`.** The latter is deprecated and tanks the pana score.
- **Date format in `CHANGELOG.md` is `DD/MM/YYYY`** (e.g. `01/06/2026`). Not ISO.

## Tech & constraints

- **SDK:** Dart `>=3.6.0 <4.0.0`, Flutter `>=3.27.0` (required for `Color.withValues()`).
- **Runtime dependency:** `intl: ^0.20.1` only. The package deliberately keeps zero heavy deps — anything audio/image-related is the consumer's responsibility.
- **Lints:** `flutter_lints` + `public_member_api_docs`. `dart analyze lib/` must report **zero issues** before publishing.

## Repository layout

```
.
├── lib/                          # Published source
│   ├── chat_bubbles.dart         # Public barrel — every consumer-facing widget is re-exported here
│   ├── algo/                     # Date-chip text helpers
│   ├── bubbles/                  # All bubble shapes (normal, special_{one,two,three}, audio, image, reply, link_preview)
│   ├── date_chips/               # DateChip widget
│   ├── groups/                   # BubbleGroupBuilder + MessageGroupHelper (consecutive-sender clustering)
│   ├── indicators/               # TypingIndicator + TypingIndicatorWave
│   ├── message_bars/             # MessageBar + MessageBarStyle
│   ├── reactions/                # BubbleReaction, Reaction, ReactionPicker, ReactionOverlay
│   ├── swipe/                    # SwipeableBubble wrapper for reply/delete gestures
│   └── utils/                    # Internal helpers (status row, forwarded header) — NOT exported
├── example/                      # Runnable Flutter app showing every widget. Source-only ships to pub
├── test/                         # Widget tests
├── images/                       # README assets + pub.dev screenshot (images/logo/logo.png)
├── pubspec.yaml                  # Package manifest
├── analysis_options.yaml         # Lint config
├── .pubignore                    # Critical — excludes build/, .dart_tool/, example platform folders
├── CHANGELOG.md                  # Required by pub.dev; one section per version (newest first)
└── README.md                     # Renders on pub.dev landing page
```

### What gets published

The `.pubignore` (NOT `.gitignore`) controls the published archive. It excludes:
- `**/build/`, `**/.dart_tool/`, `**/pubspec.lock`, IDE files, `.DS_Store`
- `example/android/`, `example/ios/`, `example/web/`, etc. — only `example/lib/`, `example/pubspec.yaml`, `example/README.md` ship

A healthy archive is **~3 MB**. If `flutter pub publish --dry-run` reports significantly more, something is leaking in — fix `.pubignore` before publishing. Background: v1.9.0 shipped ~50 MB of leaked build artifacts and pana timed out, breaking the score page. The `.pubignore` was added in v1.9.1 to fix this.

## Branching & release flow

- `master` — published / stable. Tag releases here (`v1.10.0` etc.).
- `develop` — integration branch. All feature PRs target `develop`.
- Contributor PRs go to `master` directly when they're external (e.g. #64).
- Release flow: bump version on `develop` → push → merge `develop` → `master` via PR → tag → publish.

Commit-message convention: short subject line. Release commits are titled simply `v<version>` (e.g. `v1.10.0`).

## Publishing checklist

Run from the **repo root** (not from `example/` — that publishes the example app and fails with confusing errors):

```bash
# 1. Clean build artifacts so they can't leak into the archive
cd example && flutter clean && cd ..
rm -rf .dart_tool build
find . -name ".DS_Store" -delete

# 2. Bump pubspec.yaml + add CHANGELOG entry + update README version reference
# 3. Verify
dart analyze lib/                 # must be 0 issues
flutter pub publish --dry-run     # must show ~3 MB and 0 warnings

# 4. Publish
flutter pub publish

# 5. Tag from master
git tag -a v<version> -m "v<version>"
git push origin v<version>
```

## Version-bump touch points

When cutting a release, exactly three files need the new version:
1. `pubspec.yaml` → `version:` line
2. `README.md` → the `chat_bubbles: ^X.Y.Z` line in the install snippet
3. `CHANGELOG.md` → new `## [X.Y.Z] - DD/MM/YYYY` section at the top (date is DD/MM/YYYY in this project)

Semver guidance for this package:
- **Patch (x.y.Z):** bug fixes only, no public API change
- **Minor (x.Y.0):** new widgets, new optional parameters, new exports
- **Major (X.0.0):** removed/renamed widgets, required-parameter changes, min-SDK bumps that cut off live users

## Adding a new widget

1. Drop the `.dart` file under the right subfolder in `lib/` (or make a new subfolder if it's a new category).
2. Add `export 'subfolder/your_widget.dart';` to `lib/chat_bubbles.dart`. **Forgetting this is the #1 way a feature ships but is unreachable by consumers** — caught it on v1.10.0's `MessageBarStyle`.
3. Add a `[YourWidget]` line to the dartdoc comment block at the top of `lib/chat_bubbles.dart` under the matching category header.
4. Add a demo section to `example/lib/main.dart`.
5. Document parameters with `///` (the `public_member_api_docs` lint will fail otherwise).
6. Add an entry to [llms.txt](llms.txt) under the matching section so AI agents using the package can discover it.
7. If the widget has non-obvious usage, add a recipe to [doc/recipes.md](doc/recipes.md).

## Things that have bitten us

- **Pana timeout on oversized archive** (v1.9.0) — fixed with `.pubignore` in v1.9.1.
- **Deprecated `Color.withOpacity()`** — pana flags as 15+ analyzer infos and drops the score. Use `Color.withValues(alpha: x)` instead (Flutter 3.27+).
- **Running publish from `example/`** — publishes the example app, fails with misleading "missing LICENSE" / "chat_bubbles in dev_dependencies" errors. Always publish from repo root.
- **Forgetting to re-export new public classes** from `chat_bubbles.dart` — consumers can't reach them. Caught at v1.10.0 for `MessageBarStyle`.
- **Audio playback in web demo** fails with `MEDIA_ELEMENT_ERROR` because the example pulls a sample MP3 over a URL the browser blocks. Not a package bug; ignore when web-testing the example.
