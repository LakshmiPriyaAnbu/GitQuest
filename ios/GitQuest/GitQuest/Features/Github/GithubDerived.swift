import Foundation
import SwiftUI

struct HeatmapCell: Hashable {
    let date: String
    let count: Int
    let color: String
    var uiColor: Color { Color(hex: color) }
}

struct WeeklyActivity {
    let day: String
    let pct: Int
    let count: Int
}

struct DerivedBadges {
    let streak: Bool
    let repo: Bool
    let pr: Bool
    let bughunter: Bool
}

struct RecentActivity: Identifiable {
    let icon: String
    let text: String
    let when: String
    var id: String { text + when }
}

struct DerivedGithub {
    let languages: [(name: String, pct: Int)]
    let topRepos: [(name: String, stars: Int, url: String)]
    let totalStars: Int
    let weeks: [[HeatmapCell]]
    let longestStreak: Int
    let currentStreak: Int
    let totalContributions: Int
    let weeklyActivity: [WeeklyActivity]
    let badges: DerivedBadges
    let recent: [RecentActivity]
}

private let DAY_NAMES = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

private let EVENT_VERB: [String: (String, String)] = [
    "PushEvent": ("⬆️", "pushed to"),
    "CreateEvent": ("✨", "created"),
    "PullRequestEvent": ("🎯", "opened a PR in"),
    "IssuesEvent": ("🐛", "opened an issue in"),
    "WatchEvent": ("⭐", "starred"),
    "ForkEvent": ("🍴", "forked"),
    "DeleteEvent": ("🗑️", "cleaned up"),
    "PullRequestReviewEvent": ("👀", "reviewed in"),
    "IssueCommentEvent": ("💬", "commented in"),
]

private func cellColor(_ count: Int) -> String {
    if count == 0 { return "#2E2560" }
    if count < 2 { return "#2f7d57" }
    if count < 4 { return "#37b377" }
    return "#43E197"
}

/// Day-bucketing uses a fixed UTC calendar to match GitHub's ISO8601 UTC timestamps and the
/// web version's `toISOString().slice(0,10)` behavior.
private var utcCalendar: Calendar {
    var cal = Calendar(identifier: .gregorian)
    cal.timeZone = TimeZone(identifier: "UTC")!
    return cal
}

private func dayKey(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    formatter.timeZone = TimeZone(identifier: "UTC")
    return formatter.string(from: date)
}

private func timeAgo(_ date: Date) -> String {
    let seconds = max(1, Int(Date().timeIntervalSince(date)))
    let units: [(Int, String)] = [(31_536_000, "y"), (2_592_000, "mo"), (86_400, "d"), (3600, "h"), (60, "m")]
    for (secs, label) in units where seconds >= secs {
        return "\(seconds / secs)\(label) ago"
    }
    return "just now"
}

func deriveGithubStats(_ bundle: GithubBundle) -> DerivedGithub {
    let repos = bundle.repos
    let events = bundle.events

    var langCounts: [String: Int] = [:]
    for r in repos {
        guard let lang = r.language else { continue }
        langCounts[lang, default: 0] += 1
    }
    let totalLang = max(1, langCounts.values.reduce(0, +))
    let languages = langCounts.map { name, n in (name: name, pct: max(6, Int((Double(n) / Double(totalLang) * 100).rounded()))) }
        .sorted { $0.pct > $1.pct }
        .prefix(5)
        .map { $0 }

    let topRepos = repos.sorted { $0.stargazers_count > $1.stargazers_count }
        .prefix(4)
        .map { (name: $0.name, stars: $0.stargazers_count, url: $0.html_url) }
    let totalStars = repos.reduce(0) { $0 + $1.stargazers_count }

    var countsByDay: [String: Int] = [:]
    for e in events {
        let key = dayKey(e.createdDate)
        countsByDay[key, default: 0] += 1
    }

    let today = utcCalendar.startOfDay(for: Date())
    let totalDays = 19 * 7
    var days: [HeatmapCell] = []
    for i in stride(from: totalDays - 1, through: 0, by: -1) {
        let d = today.addingTimeInterval(-Double(i) * 86400)
        let key = dayKey(d)
        let count = countsByDay[key] ?? 0
        days.append(HeatmapCell(date: key, count: count, color: cellColor(count)))
    }
    var weeks: [[HeatmapCell]] = []
    for w in 0..<19 {
        weeks.append(Array(days[(w * 7)..<(w * 7 + 7)]))
    }

    var longestStreak = 0
    var running = 0
    for d in days {
        if d.count > 0 {
            running += 1
            longestStreak = max(longestStreak, running)
        } else {
            running = 0
        }
    }
    var currentStreak = 0
    for d in days.reversed() {
        if d.count > 0 { currentStreak += 1 } else { break }
    }

    let totalContributions = events.count

    var byDow = Array(repeating: 0, count: 7)
    for e in events {
        // Calendar.component(.weekday) is 1-based Sun=1, matching JS getDay()'s 0-based Sun=0 offset by 1.
        let weekday = utcCalendar.component(.weekday, from: e.createdDate)
        byDow[weekday - 1] += 1
    }
    let maxDow = max(1, byDow.max() ?? 1)
    let weeklyActivity = DAY_NAMES.enumerated().map { i, day in
        WeeklyActivity(day: day, pct: Int((Double(byDow[i]) / Double(maxDow) * 100).rounded()), count: byDow[i])
    }

    let hasPr = events.contains { $0.type == "PullRequestEvent" }
    let hasIssue = events.contains { $0.type == "IssuesEvent" }
    let badges = DerivedBadges(streak: currentStreak >= 7, repo: repos.count >= 3, pr: hasPr, bughunter: hasIssue)

    let recent = events.prefix(8).map { e -> RecentActivity in
        let (icon, verb) = EVENT_VERB[e.type] ?? ("📌", "did something in")
        let repoName = e.repo.name.split(separator: "/").last.map(String.init) ?? e.repo.name
        return RecentActivity(icon: icon, text: "\(verb) \(repoName)", when: timeAgo(e.createdDate))
    }

    return DerivedGithub(
        languages: languages, topRepos: topRepos, totalStars: totalStars, weeks: weeks,
        longestStreak: longestStreak, currentStreak: currentStreak, totalContributions: totalContributions,
        weeklyActivity: weeklyActivity, badges: badges, recent: recent
    )
}
