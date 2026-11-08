#if os(macOS)
    import AppKit
    import Testing

    @testable import CecilyKit

    @MainActor
    struct GlassPanelTests {
        @Test func theTitleRowShowsThePanelsTitle() {
            let panel = GlassPanel(contentRect: NSRect(x: 0, y: 0, width: 400, height: 300))
            panel.setContent(NSView())
            panel.title = "Weekly review"
            #expect(labels(in: panel).contains("Weekly review"))
            panel.title = "Groceries"
            #expect(labels(in: panel).contains("Groceries"))
        }

        @Test func theContentAndActionsAreInThePanel() {
            let panel = GlassPanel(contentRect: NSRect(x: 0, y: 0, width: 400, height: 300))
            let content = NSView()
            let action = GlassPanel.actionButton("Open") {}
            panel.setContent(content, actions: [action])
            #expect(content.window === panel)
            #expect(action.window === panel)
        }

        @Test func contentCanDrawItsOwnCards() {
            let panel = GlassPanel(contentRect: NSRect(x: 0, y: 0, width: 400, height: 300))
            let content = NSView()
            panel.setContent(content, drawsCard: false)
            #expect(content.window === panel)
            #expect(GlassPanel.cardCornerRadius == GlassPanel.cornerRadius - GlassPanel.cardGap)
        }

        @Test func anActionButtonDoesItsAction() {
            var clicks = 0
            let button = GlassPanel.actionButton("Open") { clicks += 1 }
            button.performClick(nil)
            #expect(clicks == 1)
            #expect(button.borderShape == .capsule)
        }

        @Test func thePanelCanBeClosedFromTheMenu() {
            let panel = GlassPanel(contentRect: NSRect(x: 0, y: 0, width: 400, height: 300))
            let close = NSMenuItem(title: "Close", action: #selector(NSWindow.performClose(_:)), keyEquivalent: "w")
            #expect(panel.validateUserInterfaceItem(close))
            #expect(panel.canBecomeKey)
        }

        @Test func theCardsCornersAreConcentricWithThePanels() throws {
            let panel = GlassPanel(contentRect: NSRect(x: 0, y: 0, width: 400, height: 300))
            panel.setContent(NSView())
            panel.orderFront(nil)
            defer { panel.orderOut(nil) }
            panel.contentView?.layoutSubtreeIfNeeded()
            func all(_ view: NSView) -> [NSView] { [view] + view.subviews.flatMap(all) }
            let card = try #require(panel.contentView.map(all)?.first { $0 is GlassPanelFrame.Card })
            let radii = try #require(card.effectiveCornerRadii)
            let concentric = GlassPanel.cornerRadius - GlassPanel.cardGap
            #expect([radii.topLeft, radii.topRight, radii.bottomLeft, radii.bottomRight] == Array(repeating: concentric, count: 4))
        }

        private func labels(in panel: NSWindow) -> [String] {
            func all(_ view: NSView) -> [NSView] { [view] + view.subviews.flatMap(all) }
            return panel.contentView.map(all)?.compactMap { ($0 as? NSTextField)?.stringValue } ?? []
        }
    }
#endif
