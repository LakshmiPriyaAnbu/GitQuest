import SwiftUI

struct SettingsView: View {
    @Environment(GameStateStore.self) private var game
    @Environment(GitStateController.self) private var gitState
    @Environment(GithubViewModel.self) private var github
    @State private var vm: SettingsViewModel?

    var body: some View {
        Group {
            // The else branch matters: an empty Group renders nothing, so
            // .onAppear never fires and vm would never be created.
            if let vm { content(vm) } else { Color.clear }
        }
        .background(GQColor.bg.ignoresSafeArea())
        .navigationTitle("Settings")
        .onAppear { if vm == nil { vm = SettingsViewModel(game: game, gitState: gitState, github: github) } }
    }

    private func content(_ vm: SettingsViewModel) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Settings").font(GQFont.display(22)).foregroundStyle(GQColor.cream)
                Text("tune your playground").font(GQFont.hand(13)).foregroundStyle(GQColor.muted3)

                themeSection(vm)
                animSpeedSection(vm)
                cacheSection(vm)
                actionsSection(vm)
                aboutSection(vm)
            }
            .padding(16)
        }
    }

    private func themeSection(_ vm: SettingsViewModel) -> some View {
        sectionCard(title: "Theme") {
            HStack(spacing: 10) {
                swatch("Nebula", .nebula, GQColor.purple, vm)
                swatch("Candy", .candy, GQColor.pink, vm)
            }
        }
    }

    private func swatch(_ label: String, _ theme: GQTheme, _ color: Color, _ vm: SettingsViewModel) -> some View {
        Button {
            vm.setTheme(theme)
        } label: {
            VStack {
                Circle().fill(color).frame(width: 30, height: 30)
                Text(label).font(GQFont.body(11))
            }
        }
        .buttonStyle(.plain)
        .padding(8)
        .background(vm.settings.theme == theme ? GQColor.gold.opacity(0.4) : .clear)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    private func animSpeedSection(_ vm: SettingsViewModel) -> some View {
        sectionCard(title: "Animation speed") {
            Slider(value: Binding(get: { vm.settings.animSpeed }, set: { vm.setAnimSpeed($0) }), in: 0.5...2)
        }
    }

    private func cacheSection(_ vm: SettingsViewModel) -> some View {
        sectionCard(title: "GitHub") {
            Toggle("Remember GitHub username", isOn: Binding(get: { vm.settings.cacheUser }, set: { vm.toggleCacheUser($0) }))
                .tint(GQColor.mint)
        }
    }

    private func actionsSection(_ vm: SettingsViewModel) -> some View {
        sectionCard(title: "Actions") {
            VStack(spacing: 10) {
                Button("Reset playground state") { Task { await vm.resetPlayground() } }
                    .buttonStyle(.gqPink).frame(maxWidth: .infinity)

                if let doc = vm.exportSummary() {
                    ShareLink(item: doc, preview: SharePreview("gitquest-summary.json")) {
                        Text("Export activity summary").frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.gqCyan)
                }
            }
        }
    }

    private func aboutSection(_ vm: SettingsViewModel) -> some View {
        sectionCard(title: "About") {
            VStack(alignment: .leading, spacing: 3) {
                Text("XP: \(game.xp) · Level \(game.levelInfo.level)").font(GQFont.body(12))
                Text("Quests done: \(game.questsDone)/\(QUESTS.count)").font(GQFont.body(12))
                Text("Badges: \(vm.badgeCount)/\(BADGES.count)").font(GQFont.body(12))
            }
        }
    }

    private func sectionCard<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title).font(GQFont.body(12, weight: .bold)).foregroundStyle(GQColor.cream)
            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(GQColor.cream)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).stroke(GQColor.ink, lineWidth: 2))
    }
}
