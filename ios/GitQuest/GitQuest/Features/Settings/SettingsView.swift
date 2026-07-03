import SwiftUI

struct SettingsView: View {
    @Environment(GitStateController.self) private var gitState
    @Environment(GithubViewModel.self) private var github
    @Environment(GameStateStore.self) private var game
    @State private var vm: SettingsViewModel?

    var body: some View {
        Group {
            // The else branch matters: an empty Group renders nothing, so
            // .onAppear never fires and vm would never be created.
            if let vm { content(vm) } else { Color.clear }
        }
        .background(GQColor.bg.ignoresSafeArea())
        .navigationTitle(vm?.route.label ?? GQGeneratedContent.shared.shell.appTitle)
        .onAppear { if vm == nil { vm = SettingsViewModel(game: game, gitState: gitState, github: github) } }
    }

    private func content(_ vm: SettingsViewModel) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(vm.route.title).font(GQFont.display(22)).foregroundStyle(GQColor.cream)
                Text(vm.route.subtitle).font(GQFont.hand(13)).foregroundStyle(GQColor.muted3)

                themeSection(vm)
                animSpeedSection(vm)
                cacheSection(vm)
                playgroundSection(vm)
                exportSection(vm)
                aboutSection(vm)
            }
            .padding(16)
        }
    }

    private func themeSection(_ vm: SettingsViewModel) -> some View {
        sectionCard(title: vm.copy.themeTitle) {
            HStack(spacing: 10) {
                ForEach(vm.themeOptions, id: \.id) { option in
                    swatch(option.label, vm.theme(for: option.id), vm)
                }
            }
        }
    }

    private func swatch(_ label: String, _ theme: GQTheme, _ vm: SettingsViewModel) -> some View {
        Button {
            vm.setTheme(theme)
        } label: {
            VStack {
                Circle().fill(GQThemeRuntime.color(theme: theme, hexKey: "gq-bg")).frame(width: 30, height: 30)
                Text(label).font(GQFont.body(11))
            }
        }
        .buttonStyle(.plain)
        .padding(8)
        .background(vm.settings.theme == theme ? GQColor.gold.opacity(0.4) : .clear)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    private func animSpeedSection(_ vm: SettingsViewModel) -> some View {
        sectionCard(title: vm.copy.animationTitle) {
            Slider(value: Binding(get: { vm.settings.animSpeed }, set: { vm.setAnimSpeed($0) }), in: 0.5...2)
        }
    }

    private func cacheSection(_ vm: SettingsViewModel) -> some View {
        sectionCard(title: vm.copy.rememberTitle) {
            VStack(alignment: .leading, spacing: 8) {
                Toggle(vm.copy.rememberTitle, isOn: Binding(get: { vm.settings.cacheUser }, set: { vm.toggleCacheUser($0) }))
                    .tint(GQColor.mint)
                Text(vm.copy.rememberSubtitle).font(GQFont.body(11)).foregroundStyle(GQColor.textOnCream.opacity(0.7))
            }
        }
    }

    private func playgroundSection(_ vm: SettingsViewModel) -> some View {
        sectionCard(title: vm.copy.playgroundTitle) {
            Button(vm.copy.resetButton) { Task { await vm.resetPlayground() } }
                .buttonStyle(.gqPink).frame(maxWidth: .infinity)
        }
    }

    private func exportSection(_ vm: SettingsViewModel) -> some View {
        sectionCard(title: vm.copy.exportTitle) {
            if let doc = vm.exportSummary() {
                ShareLink(item: doc, preview: SharePreview(vm.copy.exportFilename)) {
                    Text(vm.copy.exportButton).frame(maxWidth: .infinity)
                }
                .buttonStyle(.gqCyan)
            }
        }
    }

    private func aboutSection(_ vm: SettingsViewModel) -> some View {
        sectionCard(title: vm.copy.aboutTitle) {
            VStack(alignment: .leading, spacing: 3) {
                ForEach(Array(vm.aboutStats.enumerated()), id: \.offset) { entry in
                    Text("\(entry.element.label): \(entry.element.value)").font(GQFont.body(12))
                }
            }
        }
    }

    private func sectionCard<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title).font(GQFont.body(12, weight: .bold)).foregroundStyle(GQColor.textOnCream)
            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(GQColor.cream)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).stroke(GQColor.ink, lineWidth: 2))
    }
}
