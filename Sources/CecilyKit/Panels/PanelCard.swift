#if os(macOS)
    import AppKit
    import SwiftUI

    extension View {
        /// Draws it on a card in a `GlassPanel` whose content draws its own cards: the window's
        /// background in a rounded rectangle with the panel's card corners. A click on the card's
        /// background goes to what's behind it.
        public func panelCard() -> some View {
            background {
                RoundedRectangle(cornerRadius: GlassPanel.cardCornerRadius, style: .continuous)
                    .fill(Color(nsColor: .windowBackgroundColor))
                    .allowsHitTesting(false)
            }
        }
    }
#endif
