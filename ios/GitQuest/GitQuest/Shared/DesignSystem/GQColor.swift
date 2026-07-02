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

/// Ports the design tokens from client/src/styles.css.
enum GQColor {
    static let ink = Color(hex: "#100B2C")
    static let bg = Color(hex: "#221A48")
    static let bgCandy = Color(hex: "#2A1B40")
    static let sidebar = Color(hex: "#1B1440")
    static let panel1 = Color(hex: "#2E2560")
    static let panel2 = Color(hex: "#1E1748")
    static let panel3 = Color(hex: "#140F30")
    static let cream = Color(hex: "#FFF4E4")
    static let textOnCream = Color(hex: "#2A2154")
    static let purple = Color(hex: "#9B7CFF")
    static let cyan = Color(hex: "#37D6E6")
    static let mint = Color(hex: "#43E197")
    static let gold = Color(hex: "#FFC24B")
    static let pink = Color(hex: "#FF6B9D")
    static let orange = Color(hex: "#FF8A4C")
    static let muted1 = Color(hex: "#6B5FA6")
    static let muted2 = Color(hex: "#8A7BC0")
    static let muted3 = Color(hex: "#B7A6FF")
    static let muted4 = Color(hex: "#A99AE0")

    /// The 6-color lane palette used by Commit Map.
    static let lanePalette: [Color] = [mint, purple, gold, pink, cyan, orange]

    static func forDifficulty(_ d: QuestDifficulty) -> Color {
        switch d {
        case .easy: return mint
        case .medium: return gold
        case .hard: return pink
        }
    }
}
