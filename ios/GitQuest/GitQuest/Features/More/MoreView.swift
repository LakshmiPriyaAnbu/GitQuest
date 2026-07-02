import SwiftUI

struct MoreItem: Identifiable {
    let destination: SecondaryDestination
    let label: String
    let icon: String
    var id: String { label }
}

private let MORE_ITEMS: [MoreItem] = [
    MoreItem(destination: .quests, label: "Quests", icon: "quest"),
    MoreItem(destination: .commandLab, label: "Command Lab", icon: "lab"),
    MoreItem(destination: .branches, label: "Branch & Merge", icon: "branch"),
    MoreItem(destination: .internals, label: "Git Internals", icon: "internals"),
    MoreItem(destination: .learn, label: "Learn", icon: "learn"),
    MoreItem(destination: .xp, label: "XP Dashboard", icon: "xp"),
    MoreItem(destination: .settings, label: "Settings", icon: "settings"),
]

struct MoreView: View {
    var body: some View {
        List(MORE_ITEMS) { item in
            NavigationLink(value: item.destination) {
                Label(item.label, systemImage: GQIcon.symbol(for: item.icon))
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(GQColor.bg.ignoresSafeArea())
        .navigationTitle("More")
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
