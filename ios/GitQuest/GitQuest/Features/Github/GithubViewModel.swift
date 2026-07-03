import Foundation

enum GithubStatus {
    case empty, loading, error, loaded
}

struct GithubStatItem: Identifiable {
    let id: String
    let label: String
    let sub: String
    let value: Int
}

/// Shared app-wide GitHub state (like the web's GithubService) so the XP screen can read the
/// same loaded profile the GitHub screen fetched, without re-fetching.
@Observable
final class GithubViewModel {
    private static let cacheKey = "gitquest_user"

    var status: GithubStatus = .empty
    var data: GithubBundle?
    var errorMessage: String = ""
    var username: String = ""

    private let api: GitQuestAPIClient
    private let game: GameStateStore

    init(api: GitQuestAPIClient = .shared, game: GameStateStore) {
        self.api = api
        self.game = game
        if game.settings.cacheUser, let cached = UserDefaults.standard.string(forKey: Self.cacheKey) {
            Task { await self.load(cached) }
        }
    }

    var route: AppRouteDescriptor {
        APP_ROUTES.first(where: { $0.id == "github" }) ?? APP_ROUTES[0]
    }

    let copy = GQGeneratedContent.shared.github

    var derived: DerivedGithub? {
        data.map(deriveGithubStats)
    }

    var gameStats: [GithubStatItem] {
        guard let derived, let user = data?.user else { return [] }
        let values: [String: Int] = [
            "contributions": derived.totalContributions,
            "streak": derived.currentStreak,
            "repositories": user.public_repos,
            "languages": derived.languages.count,
            "pullRequests": data?.events.filter { $0.type == "PullRequestEvent" }.count ?? 0,
            "stars": derived.totalStars,
        ]
        return copy.stats.map {
            GithubStatItem(id: $0.id, label: $0.label, sub: $0.sub, value: values[$0.id] ?? 0)
        }
    }

    func submit() async {
        let trimmed = username.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        await load(trimmed)
    }

    func load(_ name: String) async {
        status = .loading
        do {
            let bundle = try await api.fetchGithub(username: name)
            data = bundle
            status = .loaded
            if game.settings.cacheUser {
                UserDefaults.standard.set(name, forKey: Self.cacheKey)
            }
            game.unlock(id: "oss", title: "Open Source Adventurer")
            game.award(20, reason: "Scanned a GitHub profile")
        } catch {
            status = .error
            errorMessage = (error as? GitQuestAPIError)?.errorDescription ?? "Something went wrong reaching GitHub."
        }
    }

    func loadDemo() {
        data = buildDemoBundle()
        status = .loaded
        errorMessage = ""
    }

    func clearCache() {
        UserDefaults.standard.removeObject(forKey: Self.cacheKey)
    }
}
