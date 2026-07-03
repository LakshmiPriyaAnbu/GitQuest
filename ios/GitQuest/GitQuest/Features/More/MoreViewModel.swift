import Foundation

struct MoreMenuItem: Identifiable {
    let destination: SecondaryDestination
    let label: String
    let icon: String

    var id: String { label }
}

@Observable
final class MoreViewModel {
    let title = GQGeneratedContent.shared.shell.moreTitle

    var items: [MoreMenuItem] {
        GQGeneratedContent.shared.moreRouteIds.compactMap { routeId in
            guard let route = APP_ROUTES.first(where: { $0.id == routeId }) else { return nil }
            let destination: SecondaryDestination
            switch routeId {
            case "quests": destination = .quests
            case "commandlab": destination = .commandLab
            case "branches": destination = .branches
            case "internals": destination = .internals
            case "learn": destination = .learn
            case "xp": destination = .xp
            case "settings": destination = .settings
            default: return nil
            }
            return MoreMenuItem(destination: destination, label: route.label, icon: route.icon)
        }
    }
}
