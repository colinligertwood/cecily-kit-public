import SwiftUI

/// The three colours that mean the same in every Cecily app, wherever they show a state: text, a
/// symbol, a chip or a banner. They're never decoration or a category, and never the only sign of
/// a state, which also has its symbol or its word.
nonisolated extension ShapeStyle where Self == Color {
    /// Something's wrong and needs fixing: short, overdue, failed, sync trouble.
    public static var problem: Color { .red }
    /// Look at this: it needs a decision, or it's a warning.
    public static var caution: Color { .orange }
    /// Set aside, or not in effect: ignored, hidden, locked, unapplied changes.
    public static var setAside: Color { .gray }
}
