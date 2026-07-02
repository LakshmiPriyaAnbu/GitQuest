import XCTest

/// Exercises the real end-to-end flow against a live server/src Express backend
/// (see ios/README.md — run `npm run dev` before running this target).
final class PlaygroundFlowUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testPlaygroundInitAddCommitUpdatesVisualization() throws {
        let app = XCUIApplication()
        app.launch()

        app.tabBars.buttons["Play"].tap()

        let commandField = app.textFields["git ..."]
        XCTAssertTrue(commandField.waitForExistence(timeout: 5))

        for command in ["git init", "git add .", "git commit -m \"first\""] {
            commandField.tap()
            commandField.typeText(command)
            app.keyboards.buttons["Go"].tap()
        }

        let output = app.staticTexts.containing(NSPredicate(format: "label CONTAINS[c] 'Initialized'")).firstMatch
        XCTAssertTrue(output.waitForExistence(timeout: 5), "expected the terminal output to show the init confirmation line")
    }

    func testMoreTabReachesQuestsAndSettings() throws {
        let app = XCUIApplication()
        app.launch()

        app.tabBars.buttons["More"].tap()
        app.staticTexts["Quests"].tap()
        XCTAssertTrue(app.navigationBars["Quests"].waitForExistence(timeout: 5))

        app.navigationBars.buttons.firstMatch.tap()
        app.staticTexts["Settings"].tap()
        XCTAssertTrue(app.navigationBars["Settings"].waitForExistence(timeout: 5))
    }

    /// Every lazily-created-viewmodel screen once rendered blank (empty Group → onAppear
    /// never fired); this walks each of them and asserts the nav title actually appears.
    func testCommitMapTabAndRemainingMoreDestinationsRender() throws {
        let app = XCUIApplication()
        app.launch()

        app.tabBars.buttons["Map"].tap()
        XCTAssertTrue(app.navigationBars["Commit Map"].waitForExistence(timeout: 5))

        app.tabBars.buttons["More"].tap()
        for (row, title) in [("Command Lab", "Command Lab"), ("Branch & Merge", "Branch & Merge"), ("XP Dashboard", "XP Dashboard")] {
            app.staticTexts[row].tap()
            XCTAssertTrue(app.navigationBars[title].waitForExistence(timeout: 5), "expected \(title) to render after navigation")
            app.navigationBars.buttons.firstMatch.tap()
        }
    }

    func testGithubDemoModeLoads() throws {
        let app = XCUIApplication()
        app.launch()

        app.tabBars.buttons["GitHub"].tap()
        app.buttons["Try demo"].tap()

        XCTAssertTrue(app.staticTexts["Priya (demo)"].waitForExistence(timeout: 5))
    }
}
