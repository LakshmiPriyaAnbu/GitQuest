import Foundation

struct PlaygroundSuggestionChip: Identifiable {
    let cmd: String
    let hint: String
    var id: String { cmd }
}

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

struct PlaygroundColumn: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let color: String
}

@Observable
final class PlaygroundViewModel {
    var command: String = ""
    private let gitState: GitStateController

    init(gitState: GitStateController) {
        self.gitState = gitState
    }

    var route: AppRouteDescriptor {
        APP_ROUTES.first(where: { $0.id == "playground" }) ?? APP_ROUTES[0]
    }

    let copy = GQGeneratedContent.shared.playground
    var state: GitState? { gitState.state }

    var workingCountLabel: String { "\(state?.workingDir.count ?? 0) \(copy.countLabels.filesSuffix)" }
    var stagingCountLabel: String { "\(state?.staging.count ?? 0) \(copy.countLabels.filesSuffix)" }
    var commitCountLabel: String { "\(state?.order.count ?? 0) \(copy.countLabels.commitsSuffix)" }

    var columns: [PlaygroundColumn] {
        [
            PlaygroundColumn(id: "working", title: copy.workingDirectoryTitle, subtitle: workingCountLabel, color: "orange"),
            PlaygroundColumn(id: "staging", title: copy.stagingAreaTitle, subtitle: stagingCountLabel, color: "gold"),
            PlaygroundColumn(id: "repo", title: copy.repositoryTitle, subtitle: commitCountLabel, color: "mint"),
        ]
    }

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

    var suggestions: [PlaygroundSuggestionChip] {
        copy.suggestions.map { PlaygroundSuggestionChip(cmd: $0.cmd, hint: $0.hint) }
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
