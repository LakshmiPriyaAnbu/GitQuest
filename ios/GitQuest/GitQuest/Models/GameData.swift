import Foundation
import SwiftUI

let LEVEL_TIERS = [0, 60, 160, 320, 560, 900, 1400, 2000]
let LEVEL_TITLES = ["Newbie", "Sprout", "Committer", "Brancher", "Merge Mage", "Repo Ranger", "Git Wizard", "Legend"]

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

let QUESTS: [QuestDef] = [
    QuestDef(id: "q1", title: "Create your first repository", difficulty: .easy, minutes: 1, xp: 15, hint: "git init", route: "/playground"),
    QuestDef(id: "q2", title: "Stage your first file", difficulty: .easy, minutes: 1, xp: 15, hint: "git add index.html", route: "/playground"),
    QuestDef(id: "q3", title: "Make your first commit", difficulty: .easy, minutes: 2, xp: 20, hint: "git commit -m \"…\"", route: "/playground"),
    QuestDef(id: "q4", title: "Create a branch", difficulty: .medium, minutes: 2, xp: 15, hint: "git branch feature-ui", route: "/branches"),
    QuestDef(id: "q5", title: "Switch branches", difficulty: .medium, minutes: 1, xp: 15, hint: "git checkout feature-ui", route: "/branches"),
    QuestDef(id: "q6", title: "Merge a feature branch", difficulty: .medium, minutes: 3, xp: 25, hint: "git merge feature-ui", route: "/branches"),
    QuestDef(id: "q7", title: "Resolve a conflict", difficulty: .hard, minutes: 4, xp: 30, hint: "Conflict battle", route: "/branches"),
    QuestDef(id: "q8", title: "Read a commit graph", difficulty: .easy, minutes: 2, xp: 20, hint: "Open the map", route: "/commitmap"),
]

let BADGES: [BadgeDef] = [
    BadgeDef(id: "first-commit", emoji: "💎", title: "First Commit", hint: "Make your first commit"),
    BadgeDef(id: "brancher", emoji: "🌿", title: "Branch Explorer", hint: "Create a branch"),
    BadgeDef(id: "merger", emoji: "🔀", title: "Merge Master", hint: "Merge a branch"),
    BadgeDef(id: "streak", emoji: "🔥", title: "Streak Keeper", hint: "Reach a 7-day GitHub streak"),
    BadgeDef(id: "oss", emoji: "🧭", title: "Open Source Adventurer", hint: "Scan a GitHub profile"),
    BadgeDef(id: "bughunter", emoji: "🐛", title: "Bug Hunter", hint: "Open a GitHub issue"),
    BadgeDef(id: "repo", emoji: "🏗️", title: "Repo Builder", hint: "Have 3+ public repos"),
    BadgeDef(id: "pr", emoji: "🎯", title: "Pull Request Hero", hint: "Open a pull request"),
]

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
