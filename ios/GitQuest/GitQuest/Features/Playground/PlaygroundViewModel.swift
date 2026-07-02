import Foundation

struct PlaygroundSuggestion: Identifiable {
    let cmd: String
    let hint: String
    var id: String { cmd }
}

let PLAYGROUND_SUGGESTIONS: [PlaygroundSuggestion] = [
    PlaygroundSuggestion(cmd: "git init", hint: "Start tracking this folder"),
    PlaygroundSuggestion(cmd: "git status", hint: "See what has changed"),
    PlaygroundSuggestion(cmd: "git add .", hint: "Stage everything"),
    PlaygroundSuggestion(cmd: "git commit -m \"my first commit\"", hint: "Save a snapshot"),
    PlaygroundSuggestion(cmd: "git branch feature-ui", hint: "Fork a new path"),
    PlaygroundSuggestion(cmd: "git checkout -b feature-ui", hint: "Create and switch in one step"),
    PlaygroundSuggestion(cmd: "git merge feature-ui", hint: "Bring a branch back together"),
    PlaygroundSuggestion(cmd: "git log", hint: "See your commit history"),
]

struct RecentCommit: Identifiable {
    let sha: String
    let isHead: Bool
    let gradientIndex: Int
    var id: String { sha }
}

struct BranchPill: Identifiable {
    let name: String
    let isHead: Bool
    var id: String { name }
}

@Observable
final class PlaygroundViewModel {
    var command: String = ""
    private let gitState: GitStateController

    init(gitState: GitStateController) {
        self.gitState = gitState
    }

    var state: GitState? { gitState.state }

    var workingCountLabel: String { "\(state?.workingDir.count ?? 0) files" }
    var stagingCountLabel: String { "\(state?.staging.count ?? 0) files" }
    var commitCountLabel: String { "\(state?.order.count ?? 0) commits" }

    var recentCommits: [RecentCommit] {
        guard let s = state else { return [] }
        let headSha = s.headSha
        return s.order.suffix(6).enumerated().map { i, sha in
            RecentCommit(sha: sha, isHead: sha == headSha, gradientIndex: i % 3)
        }
    }

    var branchPills: [BranchPill] {
        guard let s = state else { return [] }
        return s.branches.keys.sorted().map { BranchPill(name: $0, isHead: $0 == s.head.ref) }
    }

    func runInput() async {
        let cmd = command.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cmd.isEmpty else { return }
        command = ""
        await gitState.run(cmd)
    }

    func runFromHistory(_ cmd: String) async {
        await gitState.run(cmd)
    }

    func reset() async {
        await gitState.reset()
    }
}
