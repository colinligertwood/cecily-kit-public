import SwiftUI

/// A drawing on a square grid: each row a string, each character a pixel in its colour, or none.
nonisolated public struct PixelMap: Sendable {
    public let rows: [String]
    public let colours: [Character: UInt32]
    /// Where the map's top-left corner sits on the grid, in pixels.
    public var origin: CGPoint
    /// How many pixels wide the grid is: the widest row, unless the drawing sits on a wider grid.
    public var columns: Int

    public init(rows: [String], colours: [Character: UInt32], origin: CGPoint = .zero, columns: Int? = nil) {
        self.rows = rows
        self.colours = colours
        self.origin = origin
        self.columns = columns ?? rows.map(\.count).max() ?? 0
    }

    /// CECILY, the brand's pixel wordmark, 55 by 10 pixels, in `ink`.
    public static func wordmark(ink: UInt32) -> PixelMap {
        PixelMap(
            rows: [
                "..KKKKKK...KKKKKKK.....KKKKKK...KK...KK........KK....KK",
                ".KKKKKKK...KKKKKKK....KKKKKKK...KK...KK........KK....KK",
                "KK.........KK........KK.........KK...KK........KK....KK",
                "KK.........KK........KK.........KK...KK.........KK..KK.",
                "KK.........KKKKKK....KK.........KK...KK..........KKKK..",
                "KK.........KKKKKK....KK.........KK...KK...........KK...",
                "KK.........KK........KK.........KK...KK...........KK...",
                "KK.........KK........KK.........KK...KK...........KK...",
                ".KKKKKKK...KKKKKKK....KKKKKKK...KK...KKKKKKK......KK...",
                "..KKKKKK...KKKKKKK.....KKKKKK...KK...KKKKKKK......KK...",
            ],
            colours: ["K": ink]
        )
    }
}

/// A `PixelMap` drawn to fill its frame's width, with square pixels.
public struct PixelArt: View {
    let map: PixelMap

    public init(map: PixelMap) {
        self.map = map
    }

    public var body: some View {
        Canvas { context, size in
            let unit = size.width / CGFloat(max(map.columns, 1))
            for (y, row) in map.rows.enumerated() {
                for (x, key) in row.enumerated() {
                    guard let hex = map.colours[key] else { continue }
                    let square = CGRect(
                        x: (CGFloat(x) + map.origin.x) * unit,
                        y: (CGFloat(y) + map.origin.y) * unit,
                        width: unit,
                        height: unit
                    )
                    // Without anti-aliasing, so neighbouring pixels meet with no hairline between them.
                    context.fill(Path(square), with: .color(Color(hex: hex)), style: FillStyle(antialiased: false))
                }
            }
        }
    }
}

extension Color {
    /// A colour from its sRGB hex value, such as `0x1A1A1A`.
    public nonisolated init(hex: UInt32) {
        self.init(
            .sRGB,
            red: Double(hex >> 16 & 0xFF) / 255,
            green: Double(hex >> 8 & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255
        )
    }
}
