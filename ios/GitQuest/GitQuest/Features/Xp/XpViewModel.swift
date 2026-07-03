import Foundation

private let LIVE_BADGE_IDS: Set<String> = ["streak", "repo", "pr", "bughunter"]

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

struct XpStatItem: Identifiable {
    let id: String
    let label: String
    let value: String
    let palette: String
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

    var route: AppRouteDescriptor {
        APP_ROUTES.first(where: { $0.id == "xp" }) ?? APP_ROUTES[0]
    }

    let copy = GQGeneratedContent.shared.xp
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
        return copy.dayNames.enumerated().map { i, day in
            WeeklyBar(day: day, pct: i < active ? 24 + ((i * 13) % 64) : 8, count: i < active ? 1 : 0)
        }
    }

    var hasGithubData: Bool { derived != nil }
    var unlockedBadgeCount: Int { badges.filter(\.unlocked).count }
    var levelInfo: LevelInfo { game.levelInfo }
    var xp: Int { game.xp }
    var questsDone: Int { game.questsDone }
    var progressLabel: String { "\(GQGeneratedContent.shared.shell.levelPrefix) \(levelInfo.level) · \(xp) \(GQGeneratedContent.shared.shell.xpSuffix)" }

    var stats: [XpStatItem] {
        let values: [String: String] = [
            "xp": String(xp),
            "rank": levelInfo.title,
            "quests": "\(questsDone)/\(QUESTS.count)",
            "badges": "\(unlockedBadgeCount)/\(BADGES.count)",
        ]
        return copy.stats.map {
            XpStatItem(id: $0.id, label: $0.label, value: values[$0.id] ?? "0", palette: $0.palette)
        }
    }
}
