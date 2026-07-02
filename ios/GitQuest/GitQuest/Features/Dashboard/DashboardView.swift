import SwiftUI

struct DashboardView: View {
    @Environment(GameStateStore.self) private var game
    @Environment(GitStateController.self) private var gitState
    @Environment(AppRouter.self) private var router

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                hero
                statsRow
                VStack(spacing: 12) {
                    ForEach(FEATURES) { feature in
                        Button {
                            router.navigate(route: feature.route)
                        } label: {
                            featureCard(feature)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(16)
        }
        .background(GQColor.bg.ignoresSafeArea())
        .navigationTitle("Home")
    }

    private var hero: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Welcome, adventurer").font(GQFont.display(26)).foregroundStyle(GQColor.cream)
            Text("your git journey starts here").font(GQFont.hand(15)).foregroundStyle(GQColor.muted3)
        }
    }

    private var statsRow: some View {
        HStack(spacing: 10) {
            statTile(value: "\(game.xp)", label: "XP")
            statTile(value: game.levelInfo.title, label: "Level \(game.levelInfo.level)")
            statTile(value: "\(gitState.state?.order.count ?? 0)", label: "Commits")
            statTile(value: "\(game.questsDone)/\(QUESTS.count)", label: "Quests")
        }
    }

    private func statTile(value: String, label: String) -> some View {
        VStack(spacing: 2) {
            Text(value).font(GQFont.display(18))
            Text(label).font(GQFont.body(11)).foregroundStyle(GQColor.textOnCream.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(GQColor.cream)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous).stroke(GQColor.ink, lineWidth: 2))
    }

    private func featureCard(_ feature: FeatureCard) -> some View {
        HStack(spacing: 14) {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(feature.iconBgColor)
                .frame(width: 48, height: 48)
                .overlay(
                    Image(systemName: GQIcon.symbol(for: feature.icon))
                        .foregroundStyle(GQColor.ink)
                )
                .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous).stroke(GQColor.ink, lineWidth: 2))

            VStack(alignment: .leading, spacing: 3) {
                Text(feature.title).font(GQFont.display(15)).foregroundStyle(GQColor.textOnCream)
                Text(feature.body).font(GQFont.body(12)).foregroundStyle(GQColor.textOnCream.opacity(0.7))
            }
            Spacer(minLength: 0)
            Image(systemName: "chevron.right").foregroundStyle(GQColor.textOnCream.opacity(0.4))
        }
        .padding(14)
        .background(GQColor.cream)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous).stroke(GQColor.ink, lineWidth: 2.5))
    }
}
