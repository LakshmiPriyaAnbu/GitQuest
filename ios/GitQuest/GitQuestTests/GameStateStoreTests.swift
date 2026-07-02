import XCTest
@testable import GitQuest

final class GameStateStoreTests: XCTestCase {
    override func setUp() {
        UserDefaults.standard.removeObject(forKey: "gitquest_game_v1")
    }

    func testAwardAddsXP() {
        let store = GameStateStore()
        store.award(20, reason: "test")
        XCTAssertEqual(store.xp, 20)
    }

    func testUnlockIsIdempotent() {
        let store = GameStateStore()
        store.unlock(id: "first-commit", title: "First Commit")
        store.unlock(id: "first-commit", title: "First Commit")
        XCTAssertEqual(store.badges.count, 1)
    }

    func testCompleteQuestAwardsXPOnce() {
        let store = GameStateStore()
        store.completeQuest(id: "q1", title: "Create your first repository", xp: 15)
        store.completeQuest(id: "q1", title: "Create your first repository", xp: 15)
        XCTAssertEqual(store.xp, 15)
        XCTAssertEqual(store.quests.count, 1)
    }

    func testLevelInfoFormula() {
        XCTAssertEqual(computeLevelInfo(xp: 0).level, 1)
        XCTAssertEqual(computeLevelInfo(xp: 59).level, 1)
        XCTAssertEqual(computeLevelInfo(xp: 60).level, 2)
        XCTAssertEqual(computeLevelInfo(xp: 2000).level, 8)
        XCTAssertTrue(computeLevelInfo(xp: 5000).maxed)
    }

    func testResetProgressKeepsSettings() {
        let store = GameStateStore()
        store.updateSettings { $0.animSpeed = 2 }
        store.award(50, reason: "test")
        store.resetProgress()
        XCTAssertEqual(store.xp, 0)
        XCTAssertEqual(store.settings.animSpeed, 2)
    }
}
