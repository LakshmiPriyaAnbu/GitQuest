import Foundation

enum GithubStatus {
    case empty, loading, error, loaded
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

    var derived: DerivedGithub? {
        data.map(deriveGithubStats)
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
