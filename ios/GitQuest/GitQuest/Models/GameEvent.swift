import Foundation

enum GameEvent: Decodable {
    case quest(id: String, title: String, xp: Int)
    case badge(id: String, title: String)
    case xp(amount: Int, reason: String)

    private enum Keys: String, CodingKey {
        case type, id, title, xp, amount, reason
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: Keys.self)
        let type = try c.decode(String.self, forKey: .type)
        switch type {
        case "quest":
            self = .quest(
                id: try c.decode(String.self, forKey: .id),
                title: try c.decode(String.self, forKey: .title),
                xp: try c.decode(Int.self, forKey: .xp)
            )
        case "badge":
            self = .badge(
                id: try c.decode(String.self, forKey: .id),
                title: try c.decode(String.self, forKey: .title)
            )
        case "xp":
            self = .xp(
                amount: try c.decode(Int.self, forKey: .amount),
                reason: try c.decode(String.self, forKey: .reason)
            )
        default:
            throw DecodingError.dataCorruptedError(forKey: .type, in: c, debugDescription: "unknown event type \(type)")
        }
    }
}
