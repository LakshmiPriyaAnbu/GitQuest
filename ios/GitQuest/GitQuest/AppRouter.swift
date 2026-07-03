import Foundation

/// Exactly 5 tabs — iOS's TabView auto-collapses a 6th+ tab into its own system "More"
/// interface (nesting our custom More screen a level deeper), so Quests lives in the
/// custom More list rather than as a 6th tab.
enum AppTab: Hashable {
    case dashboard, playground, commitMap, github, more
}

enum SecondaryDestination: Hashable {
    case quests, commandLab, branches, internals, learn, xp, settings
}

/// Central navigation: mirrors nav-data.ts's MOBILE_NAV (Dashboard/Playground/CommitMap/GitHub
/// as tabs) + everything else — including Quests — reachable via a "More" tab. Dashboard's
/// feature cards and Quests' "Start" buttons both navigate by the same web route strings
/// QuestDef/FeatureCard already use, resolved here to a tab switch or a push onto the More
/// tab's stack — never literal URL navigation.
@Observable
final class AppRouter {
    var tab: AppTab = .dashboard
    var morePath: [SecondaryDestination] = []

    private static let tabRoutes: [String: AppTab] = Dictionary(uniqueKeysWithValues: [
        ("dashboard", AppTab.dashboard),
        ("playground", .playground),
        ("commitmap", .commitMap),
        ("github", .github),
    ].compactMap { routeId, tab in
        APP_ROUTES.first(where: { $0.id == routeId }).map { ($0.path, tab) }
    })

    private static let moreRoutes: [String: SecondaryDestination] = Dictionary(uniqueKeysWithValues: [
        ("quests", SecondaryDestination.quests),
        ("commandlab", .commandLab),
        ("branches", .branches),
        ("internals", .internals),
        ("learn", .learn),
        ("xp", .xp),
        ("settings", .settings),
    ].compactMap { routeId, destination in
        APP_ROUTES.first(where: { $0.id == routeId }).map { ($0.path, destination) }
    })

    func navigate(route: String) {
        if let tab = Self.tabRoutes[route] {
            self.tab = tab
            return
        }

        guard let destination = Self.moreRoutes[route] else { return }
        open(destination)
    }

    private func open(_ destination: SecondaryDestination) {
        tab = .more
        morePath = [destination]
    }
}
