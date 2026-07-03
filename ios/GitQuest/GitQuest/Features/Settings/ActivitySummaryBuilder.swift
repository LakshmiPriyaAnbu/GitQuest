import Foundation

struct ActivitySummaryBuilder {
    let game: GameStateStore
    let gitState: GitStateController

    func buildData() -> Data? {
        struct Summary: Encodable {
            let app: String
            let generated: String
            let xp: Int
            let level: Int
            let questsCompleted: [String]
            let badges: [String]
            let commits: Int
            let branches: [String]
        }

        let state = gitState.state
        let summary = Summary(
            app: GQGeneratedContent.shared.settings.exportAppName,
            generated: ISO8601DateFormatter().string(from: Date()),
            xp: game.xp,
            level: game.levelInfo.level,
            questsCompleted: Array(game.quests.keys),
            badges: Array(game.badges.keys),
            commits: state?.order.count ?? 0,
            branches: state.map { Array($0.branches.keys) } ?? []
        )
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        return try? encoder.encode(summary)
    }
}
