import Foundation

/// The single app-wide source of truth for the simulated git repo state, mirroring the one
/// Angular signal `GitApiService.state` that Playground/Branches/CommitMap all share — every
/// screen must read/write through this one instance or tabs would show stale state.
@Observable
final class GitStateController {
    private(set) var state: GitState?
    private(set) var lastMessage: String?
    private(set) var connectionError: String?

    private let api: GitQuestAPIClient
    private let game: GameStateStore

    init(api: GitQuestAPIClient = .shared, game: GameStateStore) {
        self.api = api
        self.game = game
    }

    func refresh() async {
        do {
            state = try await api.fetchState()
            connectionError = nil
        } catch {
            connectionError = (error as? GitQuestAPIError)?.errorDescription ?? "Connection problem."
        }
    }

    @discardableResult
    func run(_ command: String) async -> Bool {
        await apply { try await self.api.runCommand(command) }
    }

    @discardableResult
    func reset() async -> Bool {
        let ok = await apply { try await self.api.reset() }
        if ok { game.toast(title: "Reset", body: "Playground reset", kind: .info) }
        return ok
    }

    @discardableResult
    func branchSim() async -> Bool { await apply { try await self.api.branchSim() } }

    @discardableResult
    func commitSim() async -> Bool { await apply { try await self.api.commitSim() } }

    @discardableResult
    func mergeSim() async -> Bool { await apply { try await self.api.mergeSim() } }

    @discardableResult
    func armConflict() async -> Bool { await apply { try await self.api.armConflict() } }

    @discardableResult
    func dismissConflict() async -> Bool { await apply { try await self.api.dismissConflict() } }

    @discardableResult
    func resolveConflict(choice: ConflictChoice) async -> Bool {
        await apply { try await self.api.resolveConflict(choice: choice) }
    }

    private func apply(_ call: @escaping () async throws -> CommandEnvelope) async -> Bool {
        do {
            let envelope = try await call()
            state = envelope.state
            lastMessage = envelope.message
            connectionError = nil
            game.applyEvents(envelope.events)
            return true
        } catch {
            connectionError = (error as? GitQuestAPIError)?.errorDescription ?? "Connection problem."
            return false
        }
    }
}
