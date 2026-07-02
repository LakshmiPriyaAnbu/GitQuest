import Foundation
import SwiftUI

enum GQTheme: String, Codable {
    case nebula, candy
}

struct GameSettings: Codable, Equatable {
    var theme: GQTheme = .nebula
    var reduceMotion: Bool = false
    var animSpeed: Double = 1
    var cacheUser: Bool = true
}

struct GameToast: Identifiable, Equatable {
    enum Kind { case xp, badge, info }
    let id: Int
    let title: String
    let body: String
    let kind: Kind
    let duration: Double
}

/// Native port of client/src/app/core/game-state.service.ts. XP/quests/badges are
/// client-local (not server-owned), persisted here via UserDefaults instead of localStorage,
/// with the same write-through-on-every-mutation behavior as the Angular `effect()`.
@Observable
final class GameStateStore {
    private(set) var xp: Int = 0
    private(set) var badges: [String: Bool] = [:]
    private(set) var quests: [String: Bool] = [:]
    var settings: GameSettings = GameSettings()
    private(set) var toasts: [GameToast] = []

    private struct Persisted: Codable {
        var xp: Int
        var badges: [String: Bool]
        var quests: [String: Bool]
        var settings: GameSettings
    }

    private static let storageKey = "gitquest_game_v1"
    private static let maxVisibleToasts = 4
    private var nextToastId = 1

    var levelInfo: LevelInfo { computeLevelInfo(xp: xp) }
    var questsDone: Int { quests.count }

    init() {
        hydrate()
    }

    func award(_ amount: Int, reason: String) {
        xp += amount
        toast(title: "+\(amount) XP", body: reason, kind: .xp)
        persist()
    }

    func unlock(id: String, title: String) {
        guard badges[id] == nil else { return }
        badges[id] = true
        toast(title: "Badge unlocked!", body: title, kind: .badge)
        persist()
    }

    func completeQuest(id: String, title: String, xp: Int? = nil) {
        guard quests[id] == nil else { return }
        quests[id] = true
        if let xp {
            award(xp, reason: "Quest: \(title)")
        } else {
            persist()
        }
    }

    func applyEvents(_ events: [GameEvent]) {
        for event in events {
            switch event {
            case .quest(let id, let title, let xp):
                completeQuest(id: id, title: title, xp: xp)
            case .badge(let id, let title):
                unlock(id: id, title: title)
            case .xp(let amount, let reason):
                award(amount, reason: reason)
            }
        }
    }

    func updateSettings(_ mutate: (inout GameSettings) -> Void) {
        mutate(&settings)
        persist()
    }

    func resetProgress() {
        xp = 0
        badges = [:]
        quests = [:]
        persist()
    }

    func toast(title: String, body: String, kind: GameToast.Kind) {
        let id = nextToastId
        nextToastId += 1
        let duration = (3200 / max(settings.animSpeed, 0.1)) / 1000
        toasts.append(GameToast(id: id, title: title, body: body, kind: kind, duration: duration))
        if toasts.count > Self.maxVisibleToasts {
            toasts.removeFirst(toasts.count - Self.maxVisibleToasts)
        }
        Task { @MainActor [weak self] in
            try? await Task.sleep(for: .seconds(duration))
            self?.dismissToast(id)
        }
    }

    func dismissToast(_ id: Int) {
        toasts.removeAll { $0.id == id }
    }

    private func persist() {
        let snapshot = Persisted(xp: xp, badges: badges, quests: quests, settings: settings)
        guard let data = try? JSONEncoder().encode(snapshot) else { return }
        UserDefaults.standard.set(data, forKey: Self.storageKey)
    }

    private func hydrate() {
        guard let data = UserDefaults.standard.data(forKey: Self.storageKey),
              let parsed = try? JSONDecoder().decode(Persisted.self, from: data) else { return }
        xp = parsed.xp
        badges = parsed.badges
        quests = parsed.quests
        settings = parsed.settings
    }
}
