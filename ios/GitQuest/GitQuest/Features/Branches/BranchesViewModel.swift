import Foundation

struct BranchRow: Identifiable {
    let name: String
    let tip: String
    let isHead: Bool
    var id: String { name }
}

@Observable
final class BranchesViewModel {
    private let gitState: GitStateController

    init(gitState: GitStateController) {
        self.gitState = gitState
    }

    var route: AppRouteDescriptor {
        APP_ROUTES.first(where: { $0.id == "branches" }) ?? APP_ROUTES[0]
    }

    let copy = GQGeneratedContent.shared.branches
    var state: GitState? { gitState.state }
    var hasRepo: Bool { state?.initialized == true }
    var conflict: GitConflict? { state?.conflict }

    var branches: [BranchRow] {
        guard let s = state else { return [] }
        return s.branches.map { name, sha in
            BranchRow(name: name, tip: sha ?? GQGeneratedContent.shared.commitMap.detailLabels.rootCommit, isHead: name == s.head.ref)
        }.sorted { $0.name < $1.name }
    }

    func newBranch() async { await gitState.branchSim() }
    func commitHere() async { await gitState.commitSim() }
    func mergeMain() async { await gitState.mergeSim() }
    func startConflict() async { await gitState.armConflict() }
    func cancelConflict() async { await gitState.dismissConflict() }
    func resolve(_ choice: ConflictChoice) async { await gitState.resolveConflict(choice: choice) }

    /// Switching branches isn't a dedicated endpoint — it's a real terminal command dispatched
    /// through the same /api/git/command path Playground uses.
    func switchTo(_ name: String) async { await gitState.run("git checkout \(name)") }
}
