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
    private let router: AppRouter

    init(game: GameStateStore, router: AppRouter) {
        self.game = game
        self.router = router
    }

    var route: AppRouteDescriptor {
        APP_ROUTES.first(where: { $0.id == "quests" }) ?? APP_ROUTES[0]
    }

    let copy = GQGeneratedContent.shared.quests

    func statusLabel(for row: QuestRow) -> String {
        if row.isDone { return copy.statusDone }
        if row.available { return copy.statusAvailable }
        return copy.statusLocked
    }

    func open(_ row: QuestRow) {
        router.navigate(route: row.def.route)
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
