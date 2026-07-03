import Foundation

@Observable
final class InternalsViewModel {
    var route: AppRouteDescriptor {
        APP_ROUTES.first(where: { $0.id == "internals" }) ?? APP_ROUTES[0]
    }

    var cards: [ConceptCard] { INTERNALS_CARDS }
}
