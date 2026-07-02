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

    func navigate(route: String) {
        switch route {
        case "/dashboard": tab = .dashboard
        case "/playground": tab = .playground
        case "/commitmap": tab = .commitMap
        case "/github": tab = .github
        case "/quests": open(.quests)
        case "/commandlab": open(.commandLab)
        case "/branches": open(.branches)
        case "/internals": open(.internals)
        case "/learn": open(.learn)
        case "/xp": open(.xp)
        case "/settings": open(.settings)
        default: break
        }
    }

    private func open(_ destination: SecondaryDestination) {
        tab = .more
        morePath = [destination]
    }
}
