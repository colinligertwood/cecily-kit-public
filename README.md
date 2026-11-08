# CecilyKit

A Swift package with what's the same in the Cecily apps, Cecily Budget, Cecily Cards and Cecily Tasks: the brand's header, the Mac's About window, the colour and text roles, and the Mac's glass panels. It needs macOS 27 or iOS 26. Each app depends on this package by its GitHub URL and describes its own brand with an `AppBrand`: its name and its tagline. The header shows the app's own icon: on the Mac, the app icon; on iPhone and iPad, an image named `BrandIcon` in the app's assets.

```swift
import CecilyKit

extension AppBrand {
    static let cards = AppBrand(name: "Cards", tagline: "Always square with the bank.")
}

// The app menu's About command, on the Mac.
.commands { AboutCommands(.cards) }

// The welcome screen's header.
BrandHeader(.cards)
```

- **`BrandHeader`**: the app's icon, CECILY with its rust square, and the app's name. On the Mac, CECILY and the name are in Silom; on iPhone and iPad, CECILY is the brand's pixel wordmark and the name is in the system font. Content passed to it goes under the name.
- **`AboutWindow`** and **`AboutCommands`** (Mac): the header with the version, a dotted rule, the tagline and the copyright.
- **The colour roles**: `.problem` (red: something's wrong), `.caution` (orange: look at this) and `.setAside` (grey: set aside, or not in effect), for a state shown as text, a symbol, a chip or a banner, as in `.foregroundStyle(.caution)`. Actions, such as a red Delete swipe, keep the system's own colours.
- **The text roles**: `TextRole`'s six kinds of text, each a system text style at its own size: `.title` (an open thing's name, a figure's value), `.heading` (a sheet's or an inspector's), `.section` (a section's or a box's heading), `.row` (a row's title), `.detail` (a row's details, banners, notes under a control) and `.caption` (labels under figures, small print). In SwiftUI, `.font(.role(.section))`; on the Mac in AppKit, `NSFont.role(.section)`. Amounts add `.monospacedDigit()`.
- **`GlassPanel`** (Mac): a floating panel framed as Quick Look's is: borderless glass with rounded corners, a title row with a close button, the panel's title and its actions, which drags the panel, and the content in a card inset from the glass. `setContent(_:actions:)` gives it its content and the title row's buttons; `GlassPanel.actionButton(_:action:)` makes a capsule button for the row. With `drawsCard: false` the content is on the glass and draws cards of its own, each with `.panelCard()`, `GlassPanel.cardGap` apart. Subclass it to change how it closes.
- **`RoundedWindowContent`** (Mac): a borderless window's content view that gives the window rounded corners, so its edge and shadow follow them, with the content drawn on top, such as SwiftUI's glass in the same shape.
- **`PixelMap`** and **`PixelArt`**: a drawing on a square grid, drawn without anti-aliasing so its pixels meet cleanly. `PixelMap.wordmark(ink:)` is CECILY.

## Working on it

```bash
swift build
swift test
xcodebuild -scheme CecilyKit -destination 'generic/platform=iOS Simulator' build
swift format format --in-place --recursive --parallel Sources Tests
```

To change it alongside an app, drag this folder into the app's Xcode project: Xcode uses the local copy in place of the GitHub one while it's there. Tag each change (`0.1.0`, `0.2.0`…), then raise the app's version of the package.

## Licence

The code is under the MIT licence: see `LICENSE`. The Cecily name, mark, wordmark and icons aren't covered by it: see `NOTICE`.

## Issues

Bug reports and ideas are welcome as issues; pull requests aren't accepted for now. See `CONTRIBUTING.md`, and `SECURITY.md` for reporting a security problem.
