import Foundation

struct GhUser: Codable, Hashable {
    let login: String
    let name: String?
    let avatar_url: String?
    let bio: String?
    let public_repos: Int
    let followers: Int
    let following: Int
}

struct GhRepo: Codable, Hashable, Identifiable {
    let name: String
    let language: String?
    let stargazers_count: Int
    let html_url: String
    var id: String { name }
}

struct GhEventRepo: Codable, Hashable {
    let name: String
}

struct GhEvent: Codable, Hashable {
    let type: String
    let created_at: String
    let repo: GhEventRepo

    var createdDate: Date {
        ISO8601DateFormatter().date(from: created_at) ?? Date()
    }
}

struct GithubBundle: Codable, Hashable {
    let user: GhUser
    let repos: [GhRepo]
    let events: [GhEvent]
    var demo: Bool = false
}

struct APIErrorBody: Decodable {
    let error: String
    let message: String
}
