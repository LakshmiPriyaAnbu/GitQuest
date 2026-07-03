import SwiftUI

struct XpView: View {
    @Environment(GameStateStore.self) private var game
    @Environment(GitStateController.self) private var gitState
    @Environment(GithubViewModel.self) private var github
    @State private var vm: XpViewModel?

    var body: some View {
        Group {
            // The else branch matters: an empty Group renders nothing, so
            // .onAppear never fires and vm would never be created.
            if let vm { content(vm) } else { Color.clear }
        }
        .background(GQColor.bg.ignoresSafeArea())
        .navigationTitle(vm?.route.label ?? GQGeneratedContent.shared.shell.appTitle)
        .onAppear { if vm == nil { vm = XpViewModel(game: game, gitState: gitState, github: github) } }
    }

    private func content(_ vm: XpViewModel) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Text(vm.route.title).font(GQFont.display(22)).foregroundStyle(GQColor.cream)
                Text(vm.route.subtitle).font(GQFont.hand(13)).foregroundStyle(GQColor.muted3)

                rankCard(vm)
                weeklyChart(vm)
                badgeGrid(vm)
            }
            .padding(16)
        }
    }

    private func rankCard(_ vm: XpViewModel) -> some View {
        VStack(spacing: 10) {
            Text(vm.levelInfo.title).font(GQFont.display(24))
            Text(vm.progressLabel).font(GQFont.body(13))
            ProgressView(value: Double(vm.levelInfo.pct), total: 100)
                .tint(GQColor.mint)
            HStack(spacing: 8) {
                ForEach(vm.stats) { stat in
                    statChip(stat)
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(GQColor.cream)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous).stroke(GQColor.ink, lineWidth: 2.5))
    }

    private func statChip(_ stat: XpStatItem) -> some View {
        let palette = GQThemeRuntime.statPalettes[stat.palette]
        VStack {
            Text(stat.value).font(GQFont.display(14)).foregroundStyle(palette?.value ?? GQColor.textOnCream)
            Text(stat.label).font(GQFont.body(10)).foregroundStyle(palette?.label ?? GQColor.textOnCream.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(palette?.bg ?? GQColor.cream.opacity(0.85))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }

    private func weeklyChart(_ vm: XpViewModel) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(vm.hasGithubData ? vm.copy.weeklyActivityTitle : "\(vm.copy.weeklyActivityTitle) (estimated)")
                .font(GQFont.body(12, weight: .bold)).foregroundStyle(GQColor.cream)
            HStack(alignment: .bottom, spacing: 8) {
                ForEach(vm.weeklyBars) { bar in
                    VStack {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(GQColor.mint)
                            .frame(height: CGFloat(bar.pct) * 0.6)
                        Text(bar.day).font(GQFont.body(9)).foregroundStyle(GQColor.muted3)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .frame(height: 100, alignment: .bottom)
            if !vm.hasGithubData {
                Text(vm.copy.chartNote).font(GQFont.body(10)).foregroundStyle(GQColor.muted3)
            }
        }
    }

    private func badgeGrid(_ vm: XpViewModel) -> some View {
        let columns = [GridItem(.adaptive(minimum: 90), spacing: 8)]
        return VStack(alignment: .leading, spacing: 8) {
            Text(vm.copy.badgesTitle).font(GQFont.body(12, weight: .bold)).foregroundStyle(GQColor.cream)
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(vm.badges) { row in
                    BadgeChipView(badge: row.def, unlocked: row.unlocked)
                }
            }
        }
    }
}
