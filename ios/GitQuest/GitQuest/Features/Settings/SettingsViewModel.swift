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
    private let summaryBuilder: ActivitySummaryBuilder

    init(game: GameStateStore, gitState: GitStateController, github: GithubViewModel) {
        self.game = game
        self.gitState = gitState
        self.github = github
        self.summaryBuilder = ActivitySummaryBuilder(game: game, gitState: gitState)
    }

    var route: AppRouteDescriptor {
        APP_ROUTES.first(where: { $0.id == "settings" }) ?? APP_ROUTES[0]
    }

    let copy = GQGeneratedContent.shared.settings
    var settings: GameSettings { game.settings }
    var badgeCount: Int { game.badges.count }
    var themeOptions: [ThemeOptionCopy] { copy.themes }

    var aboutStats: [(label: String, value: String)] {
        let values: [String: String] = [
            "xp": "\(game.xp)",
            "rank": game.levelInfo.title,
            "quests": "\(game.questsDone)/\(QUESTS.count)",
            "badges": "\(badgeCount)/\(BADGES.count)",
        ]
        return copy.about.map { (label: $0.label, value: values[$0.id] ?? "0") }
    }

    func theme(for id: String) -> GQTheme {
        id == GQTheme.candy.rawValue ? .candy : .nebula
    }

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
        guard let data = summaryBuilder.buildData() else { return nil }
        return ActivitySummaryDocument(data: data)
    }
}
