#if os(macOS)
    import AppKit
    import SwiftUI

    /// The About window: the brand's header, with the version under the app's name, then a dotted
    /// rule, the tagline and the copyright, all in Silom.
    @MainActor
    public enum AboutWindow {
        private static var window: NSWindow?

        /// Shows the window for `brand`, or brings it to the front.
        public static func show(for brand: AppBrand) {
            let shown = window ?? make(for: brand)
            window = shown
            shown.makeKeyAndOrderFront(nil)
            NSApp.activate()
        }

        private static func make(for brand: AppBrand) -> NSWindow {
            let content = NSHostingView(rootView: AboutView(brand: brand))
            let made = NSWindow(
                contentRect: NSRect(origin: .zero, size: content.fittingSize),
                styleMask: [.titled, .closable],
                backing: .buffered,
                defer: false
            )
            made.title = "About \(brand.fullName)"
            made.titleVisibility = .hidden
            made.titlebarAppearsTransparent = true
            made.isReleasedWhenClosed = false
            made.isExcludedFromWindowsMenu = true
            made.contentView = content
            made.center()
            return made
        }
    }

    /// The app menu's About command, opening `AboutWindow`.
    public struct AboutCommands: Commands {
        let brand: AppBrand

        public init(_ brand: AppBrand) {
            self.brand = brand
        }

        public var body: some Commands {
            CommandGroup(replacing: .appInfo) {
                Button("About \(brand.fullName)") { AboutWindow.show(for: brand) }
            }
        }
    }

    private struct AboutView: View {
        let brand: AppBrand

        @Environment(\.colorScheme) private var colorScheme

        private var isDark: Bool { colorScheme == .dark }

        private var version: String {
            Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
        }

        var body: some View {
            BrandHeader(brand, subtitle: "Version \(version)") {
                DottedRule(color: BrandColour.ink(isDark: isDark))
                Text(brand.tagline)
                    .font(BrandType.silom(17))
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
                Text(verbatim: brand.copyright)
                    .font(BrandType.silom(11))
                    .lineSpacing(2)
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundStyle(BrandColour.secondary(isDark: isDark))
            }
            .padding(EdgeInsets(top: 18, leading: 28, bottom: 26, trailing: 32))
            .frame(width: 480, alignment: .leading)
        }
    }

    /// A one-point dotted line across the window: a dot, then a gap of two.
    private struct DottedRule: View {
        let color: Color

        var body: some View {
            Canvas { context, size in
                var x: CGFloat = 0
                while x < size.width {
                    context.fill(Path(CGRect(x: x, y: 0, width: 1, height: 1)), with: .color(color))
                    x += 3
                }
            }
            .frame(height: 1)
            .accessibilityHidden(true)
        }
    }
#endif
