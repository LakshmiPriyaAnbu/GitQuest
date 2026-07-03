import SwiftUI

struct MoreView: View {
    private let vm = MoreViewModel()

    var body: some View {
        List(vm.items) { item in
            NavigationLink(value: item.destination) {
                Label(item.label, systemImage: GQIcon.symbol(for: item.icon))
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(GQColor.bg.ignoresSafeArea())
        .navigationTitle(vm.title)
        .navigationDestination(for: SecondaryDestination.self) { destination in
            destinationView(destination)
        }
    }

    @ViewBuilder
    private func destinationView(_ destination: SecondaryDestination) -> some View {
        switch destination {
        case .quests: QuestsView()
        case .commandLab: CommandLabView()
        case .branches: BranchesView()
        case .internals: InternalsView()
        case .learn: LearnView()
        case .xp: XpView()
        case .settings: SettingsView()
        }
    }
}
