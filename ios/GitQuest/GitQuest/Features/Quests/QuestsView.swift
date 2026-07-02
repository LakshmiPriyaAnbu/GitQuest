import SwiftUI

struct QuestsView: View {
    @Environment(GameStateStore.self) private var game
    @Environment(AppRouter.self) private var router
    @State private var vm: QuestsViewModel?

    var body: some View {
        Group {
            // The else branch matters: an empty Group renders nothing, so
            // .onAppear never fires and vm would never be created.
            if let vm { content(vm) } else { Color.clear }
        }
        .background(GQColor.bg.ignoresSafeArea())
        .navigationTitle("Quests")
        .onAppear { if vm == nil { vm = QuestsViewModel(game: game) } }
    }

    private func content(_ vm: QuestsViewModel) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Quests").font(GQFont.display(22)).foregroundStyle(GQColor.cream)
                Text("the guided learning path").font(GQFont.hand(13)).foregroundStyle(GQColor.muted3)

                ForEach(vm.rows) { row in
                    questRow(row)
                }
            }
            .padding(16)
        }
    }

    private func questRow(_ row: QuestRow) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Circle()
                .fill(row.def.difficulty.color)
                .frame(width: 10, height: 10)
                .padding(.top, 5)

            VStack(alignment: .leading, spacing: 3) {
                Text(row.def.title).font(GQFont.display(14))
                Text("\(row.def.difficulty.rawValue) · \(row.def.minutes) min · \(row.def.xp) XP")
                    .font(GQFont.body(11)).foregroundStyle(GQColor.textOnCream.opacity(0.6))
                Text(row.def.hint).font(GQFont.mono(11)).foregroundStyle(GQColor.textOnCream.opacity(0.5))
            }

            Spacer(minLength: 0)

            if row.isDone {
                Button("Replay") { router.navigate(route: row.def.route) }.buttonStyle(.gqDefault)
            } else if row.available {
                Button("Start →") { router.navigate(route: row.def.route) }.buttonStyle(.gqPrimary)
            } else {
                Image(systemName: "lock.fill").foregroundStyle(GQColor.textOnCream.opacity(0.3))
            }
        }
        .padding(12)
        .background(row.locked ? GQColor.cream.opacity(0.5) : GQColor.cream)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).stroke(GQColor.ink, lineWidth: 2))
    }
}
