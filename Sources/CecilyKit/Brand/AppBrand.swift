import SwiftUI

/// What makes each Cecily app's brand its own: its name after CECILY, its icon's drawing and its
/// tagline. Each app makes one; the package draws it.
nonisolated public struct AppBrand: Sendable {
    /// The app's name after CECILY, such as "Cards".
    public let name: String
    /// The app icon's drawing, with no tile.
    public let icon: PixelMap
    /// The line under the About window's rule, such as "Always square with the bank."
    public let tagline: String
    public let copyright: String

    public init(name: String, icon: PixelMap, tagline: String, copyright: String = "© 2026 Colin Ligertwood. All rights reserved.") {
        self.name = name
        self.icon = icon
        self.tagline = tagline
        self.copyright = copyright
    }

    /// The app's full name, such as "Cecily Cards".
    public var fullName: String { "Cecily \(name)" }
}
