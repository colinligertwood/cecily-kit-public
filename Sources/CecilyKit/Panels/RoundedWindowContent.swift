#if os(macOS)
    import AppKit

    /// A borderless window's content view, which gives the window rounded corners: its mask is the
    /// window's shape, so the window's edge and shadow follow corners of `cornerRadius`. `content`
    /// fills it and draws on top.
    public final class RoundedWindowContent: NSVisualEffectView {
        public init(cornerRadius: CGFloat, content: NSView) {
            super.init(frame: .zero)
            material = .popover
            blendingMode = .behindWindow
            state = .followsWindowActiveState
            maskImage = Self.mask(cornerRadius: cornerRadius)
            content.translatesAutoresizingMaskIntoConstraints = false
            addSubview(content)
            NSLayoutConstraint.activate([
                content.topAnchor.constraint(equalTo: topAnchor),
                content.bottomAnchor.constraint(equalTo: bottomAnchor),
                content.leadingAnchor.constraint(equalTo: leadingAnchor),
                content.trailingAnchor.constraint(equalTo: trailingAnchor),
            ])
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        /// A rounded rectangle that stretches between its corners to any size.
        private static func mask(cornerRadius radius: CGFloat) -> NSImage {
            let edge = radius * 2 + 1
            let image = NSImage(size: NSSize(width: edge, height: edge), flipped: false) { rect in
                NSColor.black.setFill()
                NSBezierPath(roundedRect: rect, xRadius: radius, yRadius: radius).fill()
                return true
            }
            image.capInsets = NSEdgeInsets(top: radius, left: radius, bottom: radius, right: radius)
            image.resizingMode = .stretch
            return image
        }
    }
#endif
