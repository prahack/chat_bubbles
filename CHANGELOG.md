## [2.0.0-beta.1] - 07/06/2026

> Pre-release. Pin the exact version to try it: `chat_bubbles: 2.0.0-beta.1`. Stable 2.0.0 will follow once feedback is in.



### Breaking changes

* **Inline timestamp layout (WhatsApp-style).** The timestamp, "Edited" label, and sent/delivered/seen tick now render **inline on the last text line when they fit**, falling back to a new right-aligned row only when they don't. Previously they always rendered on a separate row below the message. Resolves #26.
* **Text selection (`SelectableText`) removed from `BubbleNormal`, `BubbleSpecialOne`, `BubbleSpecialTwo`, `BubbleSpecialThree`, and `BubbleReply`.** These bubbles now paint text via a custom `RenderBox` so the inline layout is possible. Long-press text-selection is no longer available out of the box — use `onLongPress` to drive your own copy/select UI, the same pattern WhatsApp / iMessage / Signal follow. Consumers who need full selection can wrap the bubble in Flutter's `SelectableRegion`. `BubbleLinkPreview` keeps a normal `Text` widget (no behavior change).

### Internals

* New internal widget `TimestampedChatMessage` (`lib/utils/timestamped_chat_message.dart`) — a `LeafRenderObjectWidget` that lays out the message text plus the timestamp+edited+icon meta block in one `RenderBox`. Based on the technique demonstrated by the Flutter team and Craig Labenz's [public gist](https://gist.github.com/craiglabenz/c6fc52e3e61f66c51f7a858115bfce51).
* The old `BubbleStatusRow` helper is retained only for `BubbleLinkPreview`, which structurally cannot put the meta inline (the link-preview card sits between text and status).
* Added 4 widget tests for `TimestampedChatMessage` covering inline-fits, wraps-below, no-meta, and combined-meta cases.

## [1.10.1] - 06/06/2026

### Documentation
* Added `llms.txt` (AI-agent entry point following the llmstxt.org standard) and `doc/recipes.md` (8 copy-paste recipes for common scenarios) — both ship with the package so consumer-side AI tooling can discover the API
* Expanded `CONTRIBUTING.md` with development setup, test-suite instructions, and a PR checklist
* Added `CLAUDE.md` / `AGENTS.md` (symlink) covering common commands, layout, and gotchas for contributors

### CI / tooling
* Added GitHub Actions workflow that runs `dart format` check, `dart analyze --fatal-infos`, `flutter test`, and `flutter pub publish --dry-run` on every push and PR to `master`/`develop`
* Added 47 widget and unit tests covering every public widget plus `MessageGroupHelper` and `Algo.dateChipText`
* Added `scripts/release.sh` to codify the publish flow into a single command
* Reformatted `lib/` to match `dart format` defaults

## [1.10.0] - 31/05/2026

### New Features
* `MessageBarStyle` — new class that consolidates `MessageBar` appearance and input config: `enabledBorder`, `focusedBorder`, `keyboardType`, `textCapitalization`, `contentPadding`, `fillColor`, `minLines`, `maxLines` (thanks @herrytco, #64)
* `MessageBar.sendButton` — optional widget parameter to replace the default send icon with any custom widget (thanks @herrytco, #64)

### Fixes
* Exported `MessageBarStyle` from `chat_bubbles.dart` so it is reachable by package consumers

## [1.9.3] - 13/05/2026

### Breaking
* Minimum supported SDK bumped to Dart 3.6 / Flutter 3.27 (required for `Color.withValues()`)

### Fixes
* Replaced deprecated `Color.withOpacity()` with `Color.withValues(alpha: ...)` across all bubble widgets to clear pana static-analysis warnings
* Migrated constructors to super-parameters (`{super.key}`) and removed an unnecessary `library` directive — clears 21 additional analyzer infos

## [1.9.1] - 13/05/2026

### Fixes
* Added `.pubignore` to exclude `build/`, `.dart_tool/`, and other generated artifacts from the published archive
* Resolves pana analysis timeout on pub.dev caused by an oversized 1.9.0 package

## [1.9.0] - 02/03/2026

### New Features

#### Message Status Enhancements
* Added `timestamp` parameter to all bubble widgets for displaying message send time
* Added `isEdited` flag that shows an italic "Edited" label next to the status area
* Added `isForwarded` flag that shows a "Forwarded" banner at the top of the bubble
* Added `messageId` parameter for programmatic message tracking
* New internal `BubbleStatusRow` helper widget for consistent status row rendering
* New internal `BubbleForwardedHeader` helper widget for the forwarded banner

#### SwipeableBubble Widget
* Added `SwipeableBubble` wrapper widget for swipe gesture support on any bubble
* Swipe-right gesture (configurable icon + color) for reply actions
* Swipe-left gesture (configurable icon + color) for delete actions
* Configurable `swipeThreshold` (default: 64 logical pixels)
* Smooth spring-back animation when threshold is not met
* Optional haptic feedback via `enableHaptics`
* Circular action icon revealed behind the bubble during swipe

#### Message Groups / Clustering
* Added `BubbleGroupBuilder` widget for automatic consecutive-sender grouping
* Added `MessageGroupHelper.compute()` utility for deriving grouping info from a flat list
* Added `GroupInfo` data class with `showTail`, `showAvatar`, `isGroupStart`, `isGroupEnd`, `isAlone`
* Configurable `groupingThreshold` (default: 1 minute) to split groups on time gaps
* Configurable `itemSpacing` and `groupSpacing` for fine-grained vertical rhythm

#### Voice Message Waveform
* `BubbleNormalAudio` now accepts `waveformData` (`List<double>`) for bar-chart waveform visualization
* Interactive waveform scrubbing via tap or horizontal drag
* `waveformActiveColor` and `waveformInactiveColor` for played/unplayed portions
* Playback speed toggle button (1x / 1.5x / 2x) via `showPlaybackSpeed`, `playbackSpeed`, and `onPlaybackSpeedChanged`
* Falls back gracefully to the existing `Slider` when `waveformData` is null

### Improvements
* Updated example app with demo sections for all v1.9.0 features
* Updated `README.md` with v1.9.0 usage examples and parameter tables
* Updated exports in `chat_bubbles.dart` for `SwipeableBubble`, `BubbleGroupBuilder`, `MessageGroupHelper`, and `GroupInfo`

## [1.8.0] - 17/01/2026

### New Features

#### BubbleReply Widget
* Added `BubbleReply` widget for displaying quoted/replied messages
* WhatsApp-style reply bubbles with original message preview
* Customizable reply indicator line color and background
* Support for sender name and message preview
* Tap callbacks for reply section interaction

#### TypingIndicator Widgets
* Added `TypingIndicator` widget with animated dots
* Added `TypingIndicatorWave` widget with wave animation style
* Customizable animation duration and colors
* Toggle visibility with `showIndicator` parameter
* Smooth animations optimized for performance

#### BubbleLinkPreview Widget
* Added `BubbleLinkPreview` widget for URL previews
* Display link metadata (title, description, image)
* Optional preview image with error handling
* Customizable preview card styling
* Support for messages with or without accompanying text

#### Reaction System
* Added `BubbleReaction` widget for emoji reactions
* Added `Reaction` data model for reaction state
* Added `ReactionPicker` widget for selecting reactions
* Added `ReactionOverlay` widget for long-press reaction selection
* Support for multiple reactions per message
* User reaction highlighting
* Customizable reaction chip styling

### Improvements
* Updated example app to showcase all new v1.8.0 features
* Added comprehensive documentation for new widgets
* Improved widget organization with new directories (indicators/, reactions/)

## [1.7.1] - 17/01/2026

### Breaking Changes
* **BREAKING:** Renamed public constants to follow lowerCamelCase naming convention:
  - `BUBBLE_RADIUS` → `defaultBubbleRadius`
  - `BUBBLE_RADIUS_IMAGE` → `defaultBubbleRadiusImage`
  - `BUBBLE_RADIUS_AUDIO` → `defaultBubbleRadiusAudio`
  
  If you were using these constants directly in your code, you'll need to update the references.

### Code Quality Improvements
* Added comprehensive documentation comments for all public members
* Removed unnecessary Container widgets in MessageBar
* Added `analysis_options.yaml` with `public_member_api_docs` lint rule
* Fixed all auto-fixable lint issues (removed unnecessary `new`, `this.`, etc.)
* Improved code formatting and style consistency

## [1.7.0] - 05/01/2025

* support up-to-date dependencies
* update the example
* update the documentation

## [1.6.0] - 20/01/2024

### For Message Bar
* Customizable text style for message bar text

### For BubbleNormal Widget

* Added optional [leading] widget for _non senders_
* Added optional [trailing] widget for _sender_
* Added [margin] and [padding] properties
* Added tap callbacks such as [onTap], [onDoubleTap] and [onLongPress].
* Changes the texts to selectable texts

### For BubbleNormalImage Widget

BubbleNormalImage Widget-
* Added optional [leading] widget for _non senders_
* Added optional [trailing] widget for _sender_
* Added [margin] and [padding] parameters
* Added Tap Callbacks such as [onTap] and [onLongPress].

### For DateChip Widget
* Fixes [DateChip] taking full width

### Other
* Updated the environment to allow support for latest dart sdks
* Updated the documentation within code to be easier to read

## [1.5.0] - 11/08/2023

* Customizable constrains for bubbles
* Customizable message bar hint text
* Customizable message bar hint style
* Update the example

## [1.4.1] - 26/01/2023

* Support up-to-date dependencies

## [1.4.0] - 29/12/2022

* Add `BubbleNormalImage` image chat bubble widget 

## [1.3.1] - 16/08/2022

* Support up-to-date dependencies

## [1.3.0] - 03/07/2022

* Add `MessageBar` widget 

## [1.2.0] - 04/02/2022

* Add iMessage's chat bubble shape bubble widget (`BubbleSpecialThree`).

## [1.1.0] - 27/06/2021

* Audio chat bubble widget(`BubbleNormalAudio`) for the bubble normal widget set.

## [1.0.0+3] - 16/05/2021

* Update `README` main example code.

## [1.0.0+2] - 15/05/2021

* dartfmt formatting.

## [1.0.0+1] - 15/05/2021

* dartfmt formatting.

## [1.0.0] - 15/05/2021

* Add `DateChip` widget

## [0.8.1] - 26/04/2021

* set priority for message status tick (seen > delivered > sent)

## [0.8.0+1] - 22/03/2021

* Update README.md example.

## [0.8.0] - 15/03/2021

* Add the option to customize the chat bubble text styles by changing `textStyle` parameter

## [0.7.9+3] - 10/03/2021

* null-safety.

## [0.7.8+2] - 21/10/2020

* dartfmt formatting.

## [0.7.8+1] - 20/07/2020

* Update README.md example.

## [0.7.8] - 20/07/2020

* Add message states(sent, delivered, seen) flag for BubbleSpecialOne and BubbleSpecialTwo.
* Update the example.

## [0.7.5+1] - 18/07/2020

* Add some dartdoc comments.

## [0.7.5] - 21/06/2020

* Add message states(sent, delivered, seen) flag for BubbleNormal.
* Update the example.

## [0.7.1+6] - 17/05/2020

* Update the example.

## [0.7.1+5] - 10/05/2020

* Update README.md file.

## [0.7.1+4] - 10/05/2020

* Update package description.

## [0.7.1+3] - 09/05/2020

* Update package description.

## [0.7.1+2] - 09/05/2020

* Update package description.

## [0.7.1+1] - 09/05/2020

* Update package description.

## [0.7.1] - 09/05/2020

* Update package description.

## [0.7.0] - 09/05/2020

* First release with an example.
