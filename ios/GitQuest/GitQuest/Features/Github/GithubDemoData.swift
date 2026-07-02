import Foundation

private let DEMO_REPOS: [GhRepo] = [
    GhRepo(name: "MiniRedis-Visualizer", language: "TypeScript", stargazers_count: 42, html_url: "#"),
    GhRepo(name: "SpendWise", language: "Swift", stargazers_count: 18, html_url: "#"),
    GhRepo(name: "GitQuest", language: "TypeScript", stargazers_count: 27, html_url: "#"),
    GhRepo(name: "Alexa-APL-UI", language: "JavaScript", stargazers_count: 9, html_url: "#"),
    GhRepo(name: "c-allocator", language: "C", stargazers_count: 5, html_url: "#"),
]

private let EVENT_CYCLE = ["PushEvent", "PushEvent", "PushEvent", "PullRequestEvent", "IssuesEvent", "WatchEvent", "CreateEvent"]

func buildDemoBundle() -> GithubBundle {
    let now = Date()
    let formatter = ISO8601DateFormatter()
    var events: [GhEvent] = []
    for i in 0..<120 {
        let daysAgo = pow(Double.random(in: 0..<1), 1.6) * 38
        let created = now.addingTimeInterval(-daysAgo * 86400)
        let repo = DEMO_REPOS[i % DEMO_REPOS.count]
        events.append(GhEvent(
            type: EVENT_CYCLE[i % EVENT_CYCLE.count],
            created_at: formatter.string(from: created),
            repo: GhEventRepo(name: "dev-priya/\(repo.name)")
        ))
    }
    events.sort { $0.createdDate > $1.createdDate }

    return GithubBundle(
        user: GhUser(login: "dev-priya", name: "Priya (demo)", avatar_url: nil, bio: "Building playful developer tools.", public_repos: DEMO_REPOS.count, followers: 58, following: 31),
        repos: DEMO_REPOS,
        events: events,
        demo: true
    )
}
