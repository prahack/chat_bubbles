# Contributor Guidelines

Thank you for your interest in contributing to `chat_bubbles`! We welcome all contributions — filing issues, opening pull requests, or helping other community members. Please skim the sections below before contributing.

## Issues

Before opening one, search existing issues to avoid duplicates. A useful bug report includes:

- A clear, descriptive title
- A detailed description of the issue, including error messages or stack traces
- Steps to reproduce
- Expected behavior
- Screenshots if relevant

## Development setup

```bash
# Required: Dart 3.6+ / Flutter 3.27+
git clone https://github.com/prahack/chat_bubbles.git
cd chat_bubbles
flutter pub get
```

To run the example app:

```bash
cd example
flutter run                  # default device
flutter run -d chrome        # web (audio playback may fail — known)
```

## Branching

- `master` — published / stable. Tagged releases live here.
- `develop` — integration branch. **All feature PRs target `develop`.**

## Running the test suite

```bash
flutter test                                              # run all tests
dart analyze --fatal-infos --fatal-warnings lib/ test/    # static analysis
dart format --output=none --set-exit-if-changed lib/ test/  # formatter check
```

All three must pass before opening a PR — CI enforces them.

## Writing tests

This is a widget package, so most tests live under `test/` and use the
`flutter_test` framework:

- **Widget tests** for anything that renders — every public widget should have at minimum a "renders without crashing" test plus a callback assertion if the widget exposes any.
- **Pure unit tests** (`package:test`) for plain Dart helpers like `MessageGroupHelper` or `Algo`.

The test folder mirrors `lib/`:

```
test/
├── bubbles/        # BubbleNormal, BubbleSpecialOne, etc.
├── date_chips/     # DateChip
├── message_bars/   # MessageBar, MessageBarStyle
├── reactions/      # BubbleReaction, ReactionPicker
├── swipe/          # SwipeableBubble
├── groups/         # BubbleGroupBuilder, MessageGroupHelper
├── indicators/     # TypingIndicator
├── algo/           # Algo, DateChipText
└── test_utils.dart # pumpInApp(...) helper
```

**Every PR that adds a public widget or changes public behavior must include corresponding tests.** A reviewer will ask for them if they're missing. See [test/bubbles/bubble_normal_test.dart](test/bubbles/bubble_normal_test.dart) for a typical pattern.

When writing widget tests, use the `pumpInApp` helper from `test/test_utils.dart` to wrap your widget in a `MaterialApp + Scaffold`.

## Pull Requests

Before opening a PR:

- [ ] Code follows the [Flutter Style Guide](https://flutter.dev/docs/development/style-guide)
- [ ] `dart format` produces no changes
- [ ] `dart analyze --fatal-infos lib/ test/` reports zero issues
- [ ] `flutter test` passes (all existing tests + your new ones)
- [ ] Any new public class/parameter has dartdoc (`public_member_api_docs` lint enforces this)
- [ ] Any new public widget is re-exported from `lib/chat_bubbles.dart`
- [ ] `CHANGELOG.md` has an entry for your change under the next version (the maintainer can also handle this on merge)
- [ ] The PR title is short and descriptive; the body explains the *why*

PRs that touch the message bar, bubbles, or any consumer-facing widget should include a screenshot or short clip showing the before/after where it makes sense.

## Coding Standards

We follow the [Flutter Style Guide](https://flutter.dev/docs/development/style-guide) and the lints in [analysis_options.yaml](analysis_options.yaml) (`flutter_lints` + `public_member_api_docs`). Run `dart format` and `dart analyze` before pushing.

## License

By contributing to this project, you agree that your contributions will be licensed under the [MIT License](LICENSE).

## Conclusion

We value your contributions and look forward to working with you. If anything is unclear, open an issue or ask in your PR.
