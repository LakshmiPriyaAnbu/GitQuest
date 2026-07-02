import Foundation

struct TerminalLine: Codable, Identifiable, Hashable {
    let k: String // sys | dim | ok | err | plain
    let t: String
    var id: String { "\(k)-\(t)" }
}

struct WorkingFile: Codable, Identifiable, Hashable {
    let name: String
    let state: String?
    var id: String { name }
}

struct StagedFile: Codable, Identifiable, Hashable {
    let name: String
    var id: String { name }
}

struct Commit: Codable, Identifiable, Hashable {
    let id: String
    let msg: String
    let parents: [String]
    let files: [String]
    let branch: String
    let time: Double
    let author: String
    let isMerge: Bool?

    var date: Date { Date(timeIntervalSince1970: time / 1000) }
}

struct GitConflict: Codable, Hashable {
    let file: String
    let ours: [String]
    let theirs: [String]
}

struct GitHead: Codable, Hashable {
    let type: String
    let ref: String
}

struct GitExplain: Codable, Hashable {
    let title: String
    let body: String
}

struct GitState: Codable, Hashable {
    let initialized: Bool
    let workingDir: [WorkingFile]
    let staging: [StagedFile]
    let commits: [String: Commit]
    let order: [String]
    let branches: [String: String?]
    let head: GitHead
    let history: [String]
    let output: [TerminalLine]
    let explain: GitExplain
    let conflict: GitConflict?

    var headSha: String? { branches[head.ref] ?? nil }
}

struct CommandEnvelope: Decodable {
    let state: GitState
    let events: [GameEvent]
    let message: String?
}
