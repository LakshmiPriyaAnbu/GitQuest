import SwiftUI

struct DashboardView: View {
    @Environment(GameStateStore.self) private var game
    @Environment(GitStateController.self) private var gitState
    @Environment(AppRouter.self) private var router
    @State private var vm: DashboardViewModel?

    var body: some View {
        Group {
            if let vm {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        hero(vm)
                        statsRow(vm)
                        VStack(spacing: 12) {
                            ForEach(vm.features) { feature in
                                Button {
                                    vm.open(feature.route)
                                } label: {
                                    featureCard(feature)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(16)
                }
            }
            else {
                Color.clear
            }
        }
        .background(GQColor.bg.ignoresSafeArea())
        .navigationTitle(vm?.route.label ?? GQGeneratedContent.shared.shell.appTitle)
        .onAppear {
            if vm == nil {
                vm = DashboardViewModel(game: game, gitState: gitState, router: router)
            }
        }
    }

    private func hero(_ vm: DashboardViewModel) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(vm.route.title).font(GQFont.display(26)).foregroundStyle(GQColor.cream)
            Text(vm.route.subtitle).font(GQFont.hand(15)).foregroundStyle(GQColor.muted3)
        }
    }

    private func statsRow(_ vm: DashboardViewModel) -> some View {
        HStack(spacing: 10) {
            ForEach(vm.stats) { item in
                statTile(item)
            }
        }
    }

    private func statTile(_ item: DashboardStatItem) -> some View {
        let palette = GQThemeRuntime.statPalettes[item.palette]
        VStack(spacing: 2) {
            Text(item.value).font(GQFont.display(18)).foregroundStyle(palette?.value ?? GQColor.textOnCream)
            Text(item.label).font(GQFont.body(11)).foregroundStyle(palette?.label ?? GQColor.textOnCream.opacity(0.7))
            Text(item.hint).font(GQFont.body(9)).foregroundStyle(palette?.label.opacity(0.8) ?? GQColor.textOnCream.opacity(0.55))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(palette?.bg ?? GQColor.cream)
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
