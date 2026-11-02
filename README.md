# CecilyKit

A Swift package with what's the same in the Cecily apps, Cecily Budget, Cecily Cards and Cecily Tasks: the brand's header, the Mac's About window and the colour roles. It needs macOS 26 or iOS 26. Each app depends on this package by its GitHub URL and describes its own brand with an `AppBrand`: its name, its icon's pixel map and its tagline.

```swift
import CecilyKit

extension AppBrand {
    static let cards = AppBrand(name: "Cards", icon: .cardsIcon, tagline: "Always square with the bank.")
}

// The app menu's About command, on the Mac.
.commands { AboutCommands(.cards) }

// The welcome screen's header.
BrandHeader(.cards)
```

- **`BrandHeader`**: the icon's drawing with no tile, CECILY with its rust square, and the app's name. On the Mac, CECILY and the name are in Silom; on iPhone and iPad, CECILY is the brand's pixel wordmark and the name is in the system font. Content passed to it goes under the name.
- **`AboutWindow`** and **`AboutCommands`** (Mac): the header with the version, a dotted rule, the tagline and the copyright.
- **The colour roles**: `.problem` (red: something's wrong), `.caution` (orange: look at this) and `.setAside` (grey: set aside, or not in effect), for a state shown as text, a symbol, a chip or a banner, as in `.foregroundStyle(.caution)`. Actions, such as a red Delete swipe, keep the system's own colours.
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
