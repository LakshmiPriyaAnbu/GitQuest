import SwiftUI

struct LearnView: View {
    private let vm = LearnViewModel()

    var body: some View {
        ConceptCardGrid(title: vm.route.title, subtitle: vm.route.subtitle, cards: vm.cards)
            .navigationTitle(vm.route.label)
    }
}
