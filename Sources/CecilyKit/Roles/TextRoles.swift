import SwiftUI

#if os(macOS)
    import AppKit
#endif

/// The six kinds of text in every Cecily app, each in one of the system's text styles at its own
/// size, so text follows the person's settings, and the same kind of text looks the same
/// everywhere: in SwiftUI as `Font.role(_:)`, and on the Mac in AppKit as `NSFont.role(_:)`.
nonisolated public enum TextRole: CaseIterable, Sendable {
    /// An open thing's name; a figure's value. Title 2, semibold.
    case title
    /// A sheet's or an inspector's heading. Title 3, semibold.
    case heading
    /// A section's or a box's heading. Headline.
    case section
    /// A row's title. Body.
    case row
    /// A row's details, banners, and notes under a control. Callout.
    case detail
    /// Labels under figures, and small print. Caption.
    case caption

    /// The system text style it's drawn in.
    public var style: Font.TextStyle {
        switch self {
        case .title: .title2
        case .heading: .title3
        case .section: .headline
        case .row: .body
        case .detail: .callout
        case .caption: .caption
        }
    }

    /// Its weight, where it's bolder than its style's own.
    public var weight: Font.Weight? {
        switch self {
        case .title, .heading: .semibold
        case .section, .row, .detail, .caption: nil
        }
    }
}

nonisolated extension Font {
    /// The font for `role`'s text.
    public static func role(_ role: TextRole) -> Font {
        let font = Font.system(role.style)
        return role.weight.map { font.weight($0) } ?? font
    }
}

#if os(macOS)
    nonisolated extension NSFont {
        /// The font for `role`'s text, the same as SwiftUI's `Font.role(_:)`.
        public static func role(_ role: TextRole) -> NSFont {
            let font = NSFont.preferredFont(forTextStyle: role.appKitStyle)
            guard let weight = role.appKitWeight else { return font }
            return NSFont.systemFont(ofSize: font.pointSize, weight: weight)
        }
    }

    nonisolated extension TextRole {
        fileprivate var appKitStyle: NSFont.TextStyle {
            switch self {
            case .title: .title2
            case .heading: .title3
            case .section: .headline
            case .row: .body
            case .detail: .callout
            case .caption: .caption1
            }
        }

        fileprivate var appKitWeight: NSFont.Weight? {
            switch self {
            case .title, .heading: .semibold
            case .section, .row, .detail, .caption: nil
            }
        }
    }
#endif
