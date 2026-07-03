import Foundation

struct DashboardStatItem: Identifiable, Hashable {
    let id: String
    let value: String
    let label: String
    let hint: String
    let palette: String
}

@Observable
final class DashboardViewModel {
    private let game: GameStateStore
    private let gitState: GitStateController
    private let router: AppRouter

    init(game: GameStateStore, gitState: GitStateController, router: AppRouter) {
        self.game = game
        self.gitState = gitState
        self.router = router
    }

    var route: AppRouteDescriptor {
        APP_ROUTES.first(where: { $0.id == "dashboard" }) ?? APP_ROUTES[0]
    }

    var features: [FeatureCard] { FEATURES }

    var stats: [DashboardStatItem] {
        let values: [String: String] = [
            "commits": "\(gitState.state?.order.count ?? 0)",
            "branches": "\(gitState.state?.branches.count ?? 0)",
            "quests": "\(game.questsDone)/\(QUESTS.count)",
            "badges": "\(game.badges.count)/\(BADGES.count)",
        ]
        return GQGeneratedContent.shared.dashboard.stats.map { stat in
            DashboardStatItem(
                id: stat.id,
                value: values[stat.id] ?? "0",
                label: stat.label,
                hint: stat.hint,
                palette: stat.palette
            )
        }
    }

    func open(_ route: String) {
        router.navigate(route: route)
    }
}
