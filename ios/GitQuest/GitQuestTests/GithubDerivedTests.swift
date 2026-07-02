import XCTest
@testable import GitQuest

final class GithubDerivedTests: XCTestCase {
    func testDemoBundleDerivesBadgesAndLanguages() {
        let bundle = buildDemoBundle()
        let derived = deriveGithubStats(bundle)

        XCTAssertTrue(derived.badges.repo, "demo has 5 repos, should satisfy the 3+ repo badge")
        XCTAssertTrue(derived.badges.pr, "demo event cycle includes PullRequestEvent")
        XCTAssertTrue(derived.badges.bughunter, "demo event cycle includes IssuesEvent")
        XCTAssertFalse(derived.languages.isEmpty)
        XCTAssertEqual(derived.weeks.count, 19)
        XCTAssertTrue(derived.weeks.allSatisfy { $0.count == 7 })
    }
}
