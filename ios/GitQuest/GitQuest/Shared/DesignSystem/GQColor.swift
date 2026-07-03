import SwiftUI

extension Color {
    init(hex: String) {
        var s = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        s = s.replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        Scanner(string: s).scanHexInt64(&rgb)
        let r = Double((rgb & 0xFF0000) >> 16) / 255
        let g = Double((rgb & 0x00FF00) >> 8) / 255
        let b = Double(rgb & 0x0000FF) / 255
        self.init(red: r, green: g, blue: b)
    }
}

enum GQColor {
    static var ink: Color { GQThemeRuntime.color(hexKey: "gq-ink") }
    static var bg: Color { GQThemeRuntime.color(hexKey: "gq-bg") }
    static var sidebar: Color { GQThemeRuntime.color(hexKey: "gq-sidebar") }
    static var panel1: Color { GQThemeRuntime.color(hexKey: "gq-panel-1") }
    static var panel2: Color { GQThemeRuntime.color(hexKey: "gq-panel-2") }
    static var panel3: Color { GQThemeRuntime.color(hexKey: "gq-panel-3") }
    static var cream: Color { GQThemeRuntime.color(hexKey: "gq-cream") }
    static var textOnCream: Color { GQThemeRuntime.color(hexKey: "gq-text-on-cream") }
    static var purple: Color { GQThemeRuntime.color(hexKey: "gq-purple") }
    static var cyan: Color { GQThemeRuntime.color(hexKey: "gq-cyan") }
    static var mint: Color { GQThemeRuntime.color(hexKey: "gq-mint") }
    static var gold: Color { GQThemeRuntime.color(hexKey: "gq-gold") }
    static var pink: Color { GQThemeRuntime.color(hexKey: "gq-pink") }
    static var orange: Color { GQThemeRuntime.color(hexKey: "gq-orange") }
    static var muted1: Color { GQThemeRuntime.color(hexKey: "gq-muted-1") }
    static var muted2: Color { GQThemeRuntime.color(hexKey: "gq-muted-2") }
    static var muted3: Color { GQThemeRuntime.color(hexKey: "gq-muted-3") }
    static var muted4: Color { GQThemeRuntime.color(hexKey: "gq-muted-4") }

    static var lanePalette: [Color] { GQThemeRuntime.lanePalette }

    static func forDifficulty(_ d: QuestDifficulty) -> Color {
        GQThemeRuntime.difficultyColor(d)
    }
}
