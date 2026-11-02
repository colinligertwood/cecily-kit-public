import CecilyKit
import SwiftUI
import Testing

struct ColourRoleTests {
    @Test func eachRoleIsItsSystemColour() {
        #expect(Color.problem == .red)
        #expect(Color.caution == .orange)
        #expect(Color.setAside == .gray)
    }
}
