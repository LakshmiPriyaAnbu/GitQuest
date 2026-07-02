import Foundation

@Observable
final class CommandLabViewModel {
    var activeId: String = LESSONS[0].id
    var quizDone: [String: Bool] = [:]
    var wrongPick: String?

    private let game: GameStateStore

    init(game: GameStateStore) {
        self.game = game
    }

    var activeLesson: Lesson {
        LESSONS.first { $0.id == activeId } ?? LESSONS[0]
    }

    func select(_ id: String) {
        activeId = id
        wrongPick = nil
    }

    func pick(_ option: QuizOption) {
        if option.correct {
            wrongPick = nil
            guard quizDone[activeId] != true else { return }
            quizDone[activeId] = true
            game.award(15, reason: "Lesson quiz cleared")
        } else {
            wrongPick = option.t
        }
    }
}
