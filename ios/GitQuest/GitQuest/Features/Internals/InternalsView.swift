import SwiftUI

struct InternalsView: View {
    private let vm = InternalsViewModel()

    var body: some View {
        ConceptCardGrid(title: vm.route.title, subtitle: vm.route.subtitle, cards: vm.cards)
            .navigationTitle(vm.route.label)
    }
}
