import CecilyKit
import Testing

struct PixelMapTests {
    @Test func theWordmarkIsTenPixelsTall() {
        let wordmark = PixelMap.wordmark(ink: 0x1A1A1A)
        #expect(wordmark.rows.count == 10)
        #expect(wordmark.columns == 55)
        #expect(wordmark.rows.allSatisfy { $0.count == 55 })
    }

    @Test func aGridCanBeWiderThanItsRows() {
        let map = PixelMap(rows: ["KK", "KK"], colours: ["K": 0], origin: .init(x: 1, y: 0), columns: 4)
        #expect(map.columns == 4)
        #expect(PixelMap(rows: ["K", "KKK"], colours: [:]).columns == 3)
    }

    @Test func aBrandIsNamedAfterCecily() {
        let brand = AppBrand(name: "Cards", tagline: "Always square with the bank.")
        #expect(brand.fullName == "Cecily Cards")
    }
}
