import SwiftUI

struct MapNode: Identifiable {
    let id: String
    let x: CGFloat
    let y: CGFloat
    let color: Color
    let isHead: Bool
    let isMerge: Bool
}

struct MapEdge {
    let from: CGPoint
    let to: CGPoint
    let color: Color
}

struct LegendEntry: Identifiable {
    let name: String
    let color: Color
    var id: String { name }
}

/// Exact port of commit-map.ts's lane/x/y/edge math.
enum CommitMapLayout {
    static let padX: CGFloat = 52
    static let padY: CGFloat = 46
    static let colX: CGFloat = 92
    static let rowY: CGFloat = 80

    /// Lane = first-seen-branch order. A plain Dictionary doesn't preserve insertion order in
    /// Swift, so lanes are tracked with an ordered array lookup instead.
    static func lanes(for state: GitState) -> [String: Int] {
        var order: [String] = []
        for id in state.order {
            guard let commit = state.commits[id] else { continue }
            if !order.contains(commit.branch) {
                order.append(commit.branch)
            }
        }
        return Dictionary(uniqueKeysWithValues: order.enumerated().map { ($1, $0) })
    }

    static func legend(lanes: [String: Int]) -> [LegendEntry] {
        lanes.sorted { $0.value < $1.value }.map { name, lane in
            LegendEntry(name: name, color: GQColor.lanePalette[lane % GQColor.lanePalette.count])
        }
    }

    static func nodes(for state: GitState, lanes: [String: Int]) -> [MapNode] {
        let headSha = state.headSha
        return state.order.enumerated().compactMap { i, id in
            guard let commit = state.commits[id] else { return nil }
            let lane = lanes[commit.branch] ?? 0
            return MapNode(
                id: id,
                x: padX + CGFloat(i) * colX,
                y: padY + CGFloat(lane) * rowY,
                color: GQColor.lanePalette[lane % GQColor.lanePalette.count],
                isHead: id == headSha,
                isMerge: commit.isMerge == true
            )
        }
    }

    static func edges(for state: GitState, nodes: [MapNode]) -> [MapEdge] {
        let byId = Dictionary(uniqueKeysWithValues: nodes.map { ($0.id, $0) })
        var out: [MapEdge] = []
        for id in state.order {
            guard let commit = state.commits[id], let child = byId[id] else { continue }
            for parentId in commit.parents {
                guard let parent = byId[parentId] else { continue }
                out.append(MapEdge(
                    from: CGPoint(x: parent.x, y: parent.y),
                    to: CGPoint(x: child.x, y: child.y),
                    color: child.color
                ))
            }
        }
        return out
    }

    static func mapSize(nodeCount: Int, laneCount: Int) -> CGSize {
        let width = max(360, padX * 2 + CGFloat(max(0, nodeCount - 1)) * colX + 30)
        let height = max(150, padY * 2 + CGFloat(max(0, max(laneCount, 1) - 1)) * rowY + 30)
        return CGSize(width: width, height: height)
    }
}

@Observable
final class CommitMapViewModel {
    var selectedId: String?
    private let gitState: GitStateController
    private let game: GameStateStore

    init(gitState: GitStateController, game: GameStateStore) {
        self.gitState = gitState
        self.game = game
        game.completeQuest(id: "q8", title: "Read a commit graph", xp: 20)
    }

    var state: GitState? { gitState.state }
    var hasCommits: Bool { (state?.order.count ?? 0) > 0 }

    var lanes: [String: Int] { state.map(CommitMapLayout.lanes) ?? [:] }
    var legend: [LegendEntry] { CommitMapLayout.legend(lanes: lanes) }
    var nodes: [MapNode] { state.map { CommitMapLayout.nodes(for: $0, lanes: lanes) } ?? [] }
    var edges: [MapEdge] { state.map { CommitMapLayout.edges(for: $0, nodes: nodes) } ?? [] }
    var mapSize: CGSize { CommitMapLayout.mapSize(nodeCount: nodes.count, laneCount: max(lanes.count, 1)) }

    var selectedCommit: Commit? {
        guard let s = state else { return nil }
        let id = selectedId ?? s.headSha
        return id.flatMap { s.commits[$0] }
    }

    func select(_ id: String) {
        selectedId = id
    }

    func formatTime(_ commit: Commit) -> String {
        commit.date.formatted(date: .abbreviated, time: .shortened)
    }
}
