import Foundation

private let LIVE_BADGE_IDS: Set<String> = ["streak", "repo", "pr", "bughunter"]
private let DAY_NAMES = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

struct BadgeRow: Identifiable {
    let def: BadgeDef
    let unlocked: Bool
    var id: String { def.id }
}

struct WeeklyBar: Identifiable {
    let day: String
    let pct: Int
    let count: Int
    var id: String { day }
}

@Observable
final class XpViewModel {
    private let game: GameStateStore
    private let gitState: GitStateController
    private let github: GithubViewModel

    init(game: GameStateStore, gitState: GitStateController, github: GithubViewModel) {
        self.game = game
        self.gitState = gitState
        self.github = github
    }

    private var derived: DerivedGithub? { github.derived }

    var badges: [BadgeRow] {
        let persisted = game.badges
        let derived = derived
        return BADGES.map { def in
            let unlocked: Bool
            if LIVE_BADGE_IDS.contains(def.id), let derived {
                switch def.id {
                case "streak": unlocked = derived.badges.streak
                case "repo": unlocked = derived.badges.repo
                case "pr": unlocked = derived.badges.pr
                case "bughunter": unlocked = derived.badges.bughunter
                default: unlocked = false
                }
            } else {
                unlocked = persisted[def.id] == true
            }
            return BadgeRow(def: def, unlocked: unlocked)
        }
    }

    var weeklyBars: [WeeklyBar] {
        if let derived {
            return derived.weeklyActivity.map { WeeklyBar(day: $0.day, pct: $0.pct, count: $0.count) }
        }
        let historyLen = gitState.state?.history.count ?? 0
        let active = min(7, historyLen)
        return DAY_NAMES.enumerated().map { i, day in
            WeeklyBar(day: day, pct: i < active ? 24 + ((i * 13) % 64) : 8, count: i < active ? 1 : 0)
        }
    }

    var hasGithubData: Bool { derived != nil }
    var unlockedBadgeCount: Int { badges.filter(\.unlocked).count }
    var levelInfo: LevelInfo { game.levelInfo }
    var xp: Int { game.xp }
    var questsDone: Int { game.questsDone }
}
