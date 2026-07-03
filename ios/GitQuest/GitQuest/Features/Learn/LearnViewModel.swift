import Foundation

@Observable
final class LearnViewModel {
    var route: AppRouteDescriptor {
        APP_ROUTES.first(where: { $0.id == "learn" }) ?? APP_ROUTES[0]
    }

    var cards: [ConceptCard] { LEARN_CARDS }
}
