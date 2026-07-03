import Foundation
import SwiftUI

enum QuestDifficulty: String {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"

    var color: Color { GQColor.forDifficulty(self) }
}

struct QuestDef: Identifiable, Hashable {
    let id: String
    let title: String
    let difficulty: QuestDifficulty
    let minutes: Int
    let xp: Int
    let hint: String
    let route: String
}

struct BadgeDef: Identifiable, Hashable {
    let id: String
    let emoji: String
    let title: String
    let hint: String
}

struct LevelInfo {
    let level: Int
    let title: String
    let pct: Int
    let toNext: Int
    let nextLevel: Int
    let maxed: Bool
}

func computeLevelInfo(xp: Int) -> LevelInfo {
    var idx = 0
    for i in 0..<LEVEL_TIERS.count where xp >= LEVEL_TIERS[i] {
        idx = i
    }
    let level = idx + 1
    let title = LEVEL_TITLES[idx]
    let maxed = idx == LEVEL_TIERS.count - 1
    let floor = LEVEL_TIERS[idx]
    let ceiling = LEVEL_TIERS[min(idx + 1, LEVEL_TIERS.count - 1)]
    let pct = maxed ? 100 : Int((Double(xp - floor) / Double(ceiling - floor) * 100).rounded())
    let toNext = maxed ? 0 : ceiling - xp
    let nextLevel = maxed ? level : level + 1
    return LevelInfo(level: level, title: title, pct: pct, toNext: toNext, nextLevel: nextLevel, maxed: maxed)
}
