import Foundation

struct QuestRow: Identifiable {
    let def: QuestDef
    let isDone: Bool
    let available: Bool
    let locked: Bool
    var id: String { def.id }
}

@Observable
final class QuestsViewModel {
    private let game: GameStateStore

    init(game: GameStateStore) {
        self.game = game
    }

    var rows: [QuestRow] {
        let done = game.quests
        var prevDone = true
        return QUESTS.map { q in
            let isDone = done[q.id] == true
            let available = prevDone && !isDone
            let locked = !prevDone && !isDone
            prevDone = isDone
            return QuestRow(def: q, isDone: isDone, available: available, locked: locked)
        }
    }
}
