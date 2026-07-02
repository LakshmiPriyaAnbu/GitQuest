import SwiftUI

/// Maps nav-data.ts's icon strings to SF Symbols.
enum GQIcon {
    static func symbol(for name: String) -> String {
        switch name {
        case "home": return "house.fill"
        case "play": return "play.fill"
        case "lab": return "flask.fill"
        case "map": return "point.topleft.down.curvedto.point.bottomright.up.fill"
        case "branch": return "arrow.triangle.branch"
        case "internals": return "cube.fill"
        case "github": return "chevron.left.forwardslash.chevron.right"
        case "xp": return "bolt.fill"
        case "quest": return "flag.checkered"
        case "learn": return "book.fill"
        case "settings": return "gearshape.fill"
        default: return "circle.fill"
        }
    }
}
