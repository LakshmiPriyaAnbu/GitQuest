import Foundation
import UniformTypeIdentifiers
import CoreTransferable

struct ActivitySummaryDocument: Transferable {
    let data: Data

    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(exportedContentType: .json) { doc in doc.data }
    }
}

@Observable
final class SettingsViewModel {
    private let game: GameStateStore
    private let gitState: GitStateController
    private let github: GithubViewModel

    init(game: GameStateStore, gitState: GitStateController, github: GithubViewModel) {
        self.game = game
        self.gitState = gitState
        self.github = github
    }

    var settings: GameSettings { game.settings }
    var badgeCount: Int { game.badges.count }

    func setTheme(_ theme: GQTheme) {
        game.updateSettings { $0.theme = theme }
    }

    func setAnimSpeed(_ value: Double) {
        game.updateSettings { $0.animSpeed = value }
    }

    func toggleCacheUser(_ checked: Bool) {
        game.updateSettings { $0.cacheUser = checked }
        if !checked { github.clearCache() }
    }

    func resetPlayground() async {
        await gitState.reset()
    }

    func exportSummary() -> ActivitySummaryDocument? {
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
            app: "GitQuest",
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
        guard let data = try? encoder.encode(summary) else { return nil }
        return ActivitySummaryDocument(data: data)
    }
}
