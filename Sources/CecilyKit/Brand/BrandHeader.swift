import SwiftUI

#if os(macOS)
    import AppKit
#endif

/// The brand's header, as the About window and the welcome screen show it: the app's icon, then
/// CECILY spaced out with its rust square, and the app's name. On the Mac, CECILY and the name are
/// in Silom; on iPhone and iPad, CECILY is the brand's pixel wordmark and the name is in the
/// system font. `details` go under the name, beside the icon.
public struct BrandHeader<Details: View>: View {
    let brand: AppBrand
    /// A line just under the name, such as the version.
    var subtitle: String?
    let details: Details

    @Environment(\.colorScheme) private var colorScheme

    private var isDark: Bool { colorScheme == .dark }

    public init(_ brand: AppBrand, subtitle: String? = nil, @ViewBuilder details: () -> Details) {
        self.brand = brand
        self.subtitle = subtitle
        self.details = details()
    }

    public var body: some View {
        HStack(alignment: .top, spacing: 24) {
            AppIconImage()
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 6) {
                    cecily
                    Text(verbatim: brand.name)
                        .font(BrandType.name)
                    if let subtitle {
                        Text(subtitle)
                            .font(BrandType.subtitle)
                            .padding(.top, 2)
                    }
                }
                .padding(.top, 4)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel([brand.fullName, subtitle].compactMap { $0 }.joined(separator: ", "))
                details
            }
        }
        .foregroundStyle(BrandColour.ink(isDark: isDark))
    }

    @ViewBuilder
    private var cecily: some View {
        #if os(macOS)
            HStack(alignment: .firstTextBaseline, spacing: 0) {
                Text(verbatim: "CECILY")
                    .font(BrandType.silom(12))
                    .tracking(12 * 0.24)
                    .opacity(0.72)
                BrandMark(isDark: isDark, side: BrandType.cecilyCapitals, lead: BrandType.cecilyCapitals * 0.5 - 12 * 0.24)
            }
        #else
            HStack(alignment: .bottom, spacing: 0) {
                PixelArt(map: .wordmark(ink: BrandColour.inkHex(isDark: isDark)))
                    .frame(width: 55, height: 10)
                    .opacity(0.72)
                BrandMark(isDark: isDark, side: BrandType.cecilyCapitals, lead: BrandType.cecilyCapitals * 0.5)
            }
        #endif
    }
}

/// The app's icon, 96 points square, as the system draws it: on the Mac the app's own icon, whose
/// tile is drawn inside a margin, so it's drawn larger, with the margin outside the 96 points; on
/// iPhone and iPad the image named BrandIcon in the app's assets.
struct AppIconImage: View {
    var body: some View {
        #if os(macOS)
            Image(nsImage: NSApplication.shared.applicationIconImage)
                .resizable()
                .interpolation(.high)
                .frame(width: 120, height: 120)
                .padding(-12)
        #else
            Image("BrandIcon")
                .resizable()
                .interpolation(.high)
                .frame(width: 96, height: 96)
        #endif
    }
}

extension BrandHeader where Details == EmptyView {
    public init(_ brand: AppBrand, subtitle: String? = nil) {
        self.init(brand, subtitle: subtitle) { EmptyView() }
    }
}

/// The brand's ink, and its secondary grey, in light and dark mode.
public enum BrandColour {
    public static func inkHex(isDark: Bool) -> UInt32 { isDark ? 0xF0EDE6 : 0x1A1A1A }
    public static func ink(isDark: Bool) -> Color { Color(hex: inkHex(isDark: isDark)) }
    public static func secondary(isDark: Bool) -> Color { Color(hex: isDark ? 0xB8B4AC : 0x4A4A4A) }
    /// The mark's rust square, lighter in dark mode.
    public static func rust(isDark: Bool) -> Color { Color(hex: isDark ? 0xE0603C : 0xC0391B) }
}

/// The header's type: Silom on the Mac (Geneva if it's missing), the system font on iPhone and iPad.
public enum BrandType {
    #if os(macOS)
        static let name = silom(34)
        static let subtitle = silom(13)
        /// The height of CECILY's capitals, to the nearest point.
        static let cecilyCapitals = (NSFont(name: "Silom", size: 12) ?? NSFont(name: "Geneva", size: 12) ?? .systemFont(ofSize: 12)).capHeight
            .rounded()

        /// Silom at `size` points, fixed, or Geneva if it's missing.
        public static func silom(_ size: CGFloat) -> Font {
            .custom(NSFont(name: "Silom", size: size) == nil ? "Geneva" : "Silom", fixedSize: size)
        }
    #else
        static let name = Font.system(size: 34, weight: .semibold)
        static let subtitle = Font.system(size: 13)
        /// The height of the pixel wordmark's capitals: all ten of its pixels.
        static let cecilyCapitals: CGFloat = 10
    #endif
}

/// The wordmark's mark beside small type: one rust square after CECILY, as tall as its capitals
/// and sitting on its baseline, half the capitals' height after it. `lead` is that gap, less the
/// letter spacing the tracking already leaves after the Y.
struct BrandMark: View {
    let isDark: Bool
    let side: CGFloat
    let lead: CGFloat

    var body: some View {
        Rectangle()
            .fill(BrandColour.rust(isDark: isDark))
            .frame(width: side, height: side)
            .padding(.leading, max(lead, 0).rounded())
            .alignmentGuide(.firstTextBaseline) { $0[.bottom] }
            .accessibilityHidden(true)
    }
}
