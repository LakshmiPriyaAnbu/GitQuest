import Foundation

enum ConflictChoice: String {
    case current, incoming, both
}

/// Talks to the same Express API the Angular client uses (server/src/routes/git.js,
/// server/src/routes/github.js). Uses the default URLSession configuration so the
/// `gitquest.sid` session cookie set by express-session is captured and replayed
/// automatically, exactly like a browser.
final class GitQuestAPIClient {
    static let shared = GitQuestAPIClient()

    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
        self.decoder = JSONDecoder()
        self.encoder = JSONEncoder()
    }

    private var base: URL { Config.apiBaseURL }

    // MARK: - Git endpoints

    func fetchState() async throws -> GitState {
        struct StateEnvelope: Decodable { let state: GitState }
        let envelope: StateEnvelope = try await get("/api/git/state")
        return envelope.state
    }

    func runCommand(_ command: String) async throws -> CommandEnvelope {
        try await postGit("/api/git/command", body: ["command": command])
    }

    func reset() async throws -> CommandEnvelope {
        try await postGit("/api/git/reset")
    }

    func branchSim() async throws -> CommandEnvelope {
        try await postGit("/api/git/branch-sim")
    }

    func commitSim() async throws -> CommandEnvelope {
        try await postGit("/api/git/commit-sim")
    }

    func mergeSim() async throws -> CommandEnvelope {
        try await postGit("/api/git/merge-sim")
    }

    func armConflict() async throws -> CommandEnvelope {
        try await postGit("/api/git/conflict/arm")
    }

    func dismissConflict() async throws -> CommandEnvelope {
        try await postGit("/api/git/conflict/dismiss")
    }

    func resolveConflict(choice: ConflictChoice) async throws -> CommandEnvelope {
        try await postGit("/api/git/conflict/resolve", body: ["choice": choice.rawValue])
    }

    // MARK: - GitHub endpoint

    func fetchGithub(username: String) async throws -> GithubBundle {
        let encoded = username.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? username
        let url = base.appendingPathComponent("api/github/\(encoded)")
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let (data, response) = try await perform(request)
        guard let http = response as? HTTPURLResponse else { throw GitQuestAPIError.transport(URLError(.badServerResponse)) }

        if http.statusCode == 404 {
            let body = try? decoder.decode(APIErrorBody.self, from: data)
            throw GitQuestAPIError.notFound(body?.message ?? "No GitHub profile found.")
        }
        if !(200..<300).contains(http.statusCode) {
            let body = try? decoder.decode(APIErrorBody.self, from: data)
            throw GitQuestAPIError.upstreamError(body?.message ?? "Could not reach GitHub. Try the demo profile instead.")
        }
        do {
            return try decoder.decode(GithubBundle.self, from: data)
        } catch {
            throw GitQuestAPIError.decoding(error)
        }
    }

    // MARK: - Helpers

    private func get<T: Decodable>(_ path: String) async throws -> T {
        var request = URLRequest(url: base.appendingPathComponent(path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))))
        request.httpMethod = "GET"
        let (data, _) = try await perform(request)
        return try decode(data)
    }

    /// `/api/git/*` always returns HTTP 200 — bad commands surface as `state.output` entries
    /// with `k: "err"`, not as thrown errors. Only genuine transport/decoding failures throw here.
    private func postGit(_ path: String, body: [String: String] = [:]) async throws -> CommandEnvelope {
        var request = URLRequest(url: base.appendingPathComponent(path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))))
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? encoder.encode(body)
        let (data, _) = try await perform(request)
        return try decode(data)
    }

    private func perform(_ request: URLRequest) async throws -> (Data, URLResponse) {
        do {
            return try await session.data(for: request)
        } catch {
            throw GitQuestAPIError.transport(error)
        }
    }

    private func decode<T: Decodable>(_ data: Data) throws -> T {
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw GitQuestAPIError.decoding(error)
        }
    }
}
