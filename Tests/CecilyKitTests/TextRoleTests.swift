import SwiftUI
import Testing

@testable import CecilyKit

#if os(macOS)
    import AppKit
#endif

struct TextRoleTests {
    @Test func thereAreSixRoles() {
        #expect(TextRole.allCases.count == 6)
    }

    @Test(arguments: [
        (TextRole.title, Font.TextStyle.title2, Font.Weight?.some(.semibold)),
        (.heading, .title3, .semibold),
        (.section, .headline, nil),
        (.row, .body, nil),
        (.detail, .callout, nil),
        (.caption, .caption, nil),
    ])
    func eachRoleHasItsStyle(role: TextRole, style: Font.TextStyle, weight: Font.Weight?) {
        #expect(role.style == style)
        #expect(role.weight == weight)
    }

    #if os(macOS)
        @Test(arguments: [
            (TextRole.title, NSFont.TextStyle.title2),
            (.heading, .title3),
            (.section, .headline),
            (.row, .body),
            (.detail, .callout),
            (.caption, .caption1),
        ])
        func appKitFontsAreTheSystemsAtTheirSizes(role: TextRole, style: NSFont.TextStyle) {
            #expect(NSFont.role(role).pointSize == NSFont.preferredFont(forTextStyle: style).pointSize)
        }

        @Test func titlesAndHeadingsAreSemibold() {
            for role in [TextRole.title, .heading] {
                let traits = NSFont.role(role).fontDescriptor.object(forKey: .traits) as? [NSFontDescriptor.TraitKey: Any]
                let weight = traits?[.weight] as? CGFloat
                #expect(weight == NSFont.Weight.semibold.rawValue)
            }
        }
    #endif
}
