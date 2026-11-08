#if os(macOS)
    import AppKit

    /// A floating panel framed as Quick Look's is: borderless glass with rounded corners, a title
    /// row along its top (a close button, the panel's title, and its actions at the right), which
    /// drags the panel, and under it the content in a card inset from the glass, its corners
    /// following the glass's. Its edge and shadow follow its corners. It can take the keyboard, and
    /// its close button and ⌘W close it through `performClose(_:)`.
    open class GlassPanel: NSPanel {
        /// The radius of the panel's corners.
        public static let cornerRadius: CGFloat = 20
        /// How far its card, or the cards its content draws, are inset from its glass, and the
        /// gap between cards.
        public static let cardGap: CGFloat = 5
        /// The radius of a card's corners, which follow the panel's.
        public static let cardCornerRadius: CGFloat = cornerRadius - cardGap
        private weak var titleLabel: NSTextField?

        public init(contentRect: NSRect) {
            super.init(contentRect: contentRect, styleMask: [.borderless, .closable, .resizable], backing: .buffered, defer: true)
            isOpaque = false
            backgroundColor = .clear
            hasShadow = true
            isFloatingPanel = true
            isReleasedWhenClosed = false
        }

        /// Shows `content` in the panel's card, filling it, with `actions` at the right of the
        /// title row, in order. Without `drawsCard`, the content is on the glass, drawing cards
        /// of its own (`panelCard()`), in the same place and with the same outer corners.
        public func setContent(_ content: NSView, actions: [NSView] = [], drawsCard: Bool = true) {
            let frame = GlassPanelFrame(panel: self, content: content, actions: actions, drawsCard: drawsCard)
            titleLabel = frame.titleLabel
            contentView = RoundedWindowContent(cornerRadius: Self.cornerRadius, content: frame)
        }

        /// A button for the title row, titled `title`, shaped as a capsule so its ends follow the
        /// panel's corners, that does `action` when it's clicked.
        public static func actionButton(_ title: String, action: @escaping () -> Void) -> NSButton {
            let button = ClosureButton(title: title, action: action)
            button.bezelStyle = .push
            button.borderShape = .capsule
            return button
        }

        open override var canBecomeKey: Bool { true }

        open override var title: String {
            didSet { titleLabel?.stringValue = title }
        }

        open override func validateUserInterfaceItem(_ item: any NSValidatedUserInterfaceItem) -> Bool {
            item.action == #selector(performClose(_:)) || super.validateUserInterfaceItem(item)
        }
    }

    /// What a `GlassPanel` draws: the glass, the title row and the card holding its content. Its
    /// corners are the panel's, which the card's follow, concentric with them.
    final class GlassPanelFrame: NSView {
        private static let inset = GlassPanel.cardGap
        private static let titleHeight: CGFloat = 30
        private static let gap: CGFloat = 8
        let titleLabel: NSTextField

        init(panel: GlassPanel, content: NSView, actions: [NSView], drawsCard: Bool) {
            titleLabel = NSTextField(labelWithString: panel.title)
            super.init(frame: .zero)
            let glass = NSGlassEffectView()
            glass.cornerRadius = GlassPanel.cornerRadius
            let titleRow = TitleRow()
            let close = NSButton(image: Self.closeImage, target: panel, action: #selector(NSWindow.performClose(_:)))
            close.isBordered = false
            close.imagePosition = .imageOnly
            close.contentTintColor = .secondaryLabelColor
            close.setAccessibilityLabel("Close")
            titleLabel.font = .systemFont(ofSize: NSFont.systemFontSize)
            titleLabel.lineBreakMode = .byTruncatingTail
            titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            let actionStack = NSStackView(views: actions)
            actionStack.orientation = .horizontal
            actionStack.spacing = Self.gap
            let card = Card(drawsBackground: drawsCard)
            for view in [glass, titleRow, card, close, titleLabel, actionStack, content] {
                view.translatesAutoresizingMaskIntoConstraints = false
            }
            addSubview(glass)
            addSubview(titleRow)
            addSubview(card)
            titleRow.addSubview(close)
            titleRow.addSubview(titleLabel)
            titleRow.addSubview(actionStack)
            card.addSubview(content)
            NSLayoutConstraint.activate([
                glass.topAnchor.constraint(equalTo: topAnchor),
                glass.bottomAnchor.constraint(equalTo: bottomAnchor),
                glass.leadingAnchor.constraint(equalTo: leadingAnchor),
                glass.trailingAnchor.constraint(equalTo: trailingAnchor),
                titleRow.topAnchor.constraint(equalTo: topAnchor, constant: Self.inset - 1),
                titleRow.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Self.gap),
                titleRow.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Self.gap),
                titleRow.heightAnchor.constraint(equalToConstant: Self.titleHeight),
                close.leadingAnchor.constraint(equalTo: titleRow.leadingAnchor, constant: Self.gap / 2),
                close.centerYAnchor.constraint(equalTo: titleRow.centerYAnchor),
                titleLabel.leadingAnchor.constraint(equalTo: close.trailingAnchor, constant: Self.gap),
                titleLabel.centerYAnchor.constraint(equalTo: titleRow.centerYAnchor),
                actionStack.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: Self.gap),
                actionStack.trailingAnchor.constraint(equalTo: titleRow.trailingAnchor),
                actionStack.centerYAnchor.constraint(equalTo: titleRow.centerYAnchor),
                card.topAnchor.constraint(equalTo: titleRow.bottomAnchor, constant: Self.inset - 1),
                card.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Self.inset),
                card.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Self.inset),
                card.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Self.inset),
                content.topAnchor.constraint(equalTo: card.topAnchor),
                content.bottomAnchor.constraint(equalTo: card.bottomAnchor),
                content.leadingAnchor.constraint(equalTo: card.leadingAnchor),
                content.trailingAnchor.constraint(equalTo: card.trailingAnchor),
            ])
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        /// The close button's: a circle 12 points across with a cross cut out of it, its arms
        /// reaching 2.6 points from the middle each way, as Quick Look's is, tinted as a template.
        private static let closeImage: NSImage = {
            let image = NSImage(size: NSSize(width: 12, height: 12), flipped: false) { rect in
                NSColor.black.setFill()
                NSBezierPath(ovalIn: rect).fill()
                NSGraphicsContext.current?.compositingOperation = .destinationOut
                let reach: CGFloat = 2.6
                let cross = NSBezierPath()
                cross.move(to: NSPoint(x: rect.midX - reach, y: rect.midY - reach))
                cross.line(to: NSPoint(x: rect.midX + reach, y: rect.midY + reach))
                cross.move(to: NSPoint(x: rect.midX - reach, y: rect.midY + reach))
                cross.line(to: NSPoint(x: rect.midX + reach, y: rect.midY - reach))
                cross.lineWidth = 1.5
                cross.lineCapStyle = .round
                cross.stroke()
                return true
            }
            image.isTemplate = true
            image.accessibilityDescription = "Close"
            return image
        }()

        /// The row along the top: a click on it, anywhere but on a button, drags the panel.
        private final class TitleRow: NSView {
            override func hitTest(_ point: NSPoint) -> NSView? {
                guard let hit = super.hitTest(point) else { return nil }
                return hit is NSButton || hit.superview is NSButton ? hit : self
            }

            override func mouseDown(with event: NSEvent) {
                window?.performDrag(with: event)
            }
        }

        override var cornerConfiguration: NSViewCornerConfiguration? {
            .corners(radius: .fixed(GlassPanel.cornerRadius))
        }

        /// The content, its corners all rounded as those concentric with the glass's are, on the
        /// window's background when it `drawsBackground`.
        final class Card: NSView {
            private let drawsBackground: Bool

            init(drawsBackground: Bool) {
                self.drawsBackground = drawsBackground
                super.init(frame: .zero)
                wantsLayer = true
                layer?.cornerCurve = .continuous
                layer?.masksToBounds = true
            }

            override var cornerConfiguration: NSViewCornerConfiguration? {
                .uniformCorners(radius: .containerConcentric)
            }

            override func viewDidChangeEffectiveCornerRadii() {
                super.viewDidChangeEffectiveCornerRadii()
                layer?.cornerRadius = effectiveCornerRadii?.topLeft ?? 0
            }

            @available(*, unavailable)
            required init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
            }

            override var wantsUpdateLayer: Bool { true }

            override func viewDidChangeEffectiveAppearance() {
                super.viewDidChangeEffectiveAppearance()
                needsDisplay = true
            }

            override func updateLayer() {
                layer?.backgroundColor = drawsBackground ? NSColor.windowBackgroundColor.cgColor : nil
            }
        }
    }

    /// A button that does `action` when it's clicked.
    private final class ClosureButton: NSButton {
        private var perform: () -> Void = {}

        convenience init(title: String, action: @escaping () -> Void) {
            self.init(frame: .zero)
            self.title = title
            perform = action
            target = self
            self.action = #selector(clicked)
        }

        @objc private func clicked() {
            perform()
        }
    }
#endif
