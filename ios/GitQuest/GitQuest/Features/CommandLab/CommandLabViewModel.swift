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

    var route: AppRouteDescriptor {
        APP_ROUTES.first(where: { $0.id == "commandlab" }) ?? APP_ROUTES[0]
    }

    let copy = GQGeneratedContent.shared.commandLab
    var lessons: [Lesson] { LESSONS }

    var activeLesson: Lesson {
        LESSONS.first { $0.id == activeId } ?? LESSONS[0]
    }

    var feedbackMessage: String? {
        if quizDone[activeId] == true { return copy.successMessage }
        if wrongPick != nil { return copy.retryMessage }
        return nil
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
            game.award(15, reason: copy.quizAwardReason)
        } else {
            wrongPick = option.t
        }
    }
}
