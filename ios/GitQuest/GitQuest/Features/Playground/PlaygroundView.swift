import SwiftUI

struct PlaygroundView: View {
    @Environment(GitStateController.self) private var gitState
    @State private var vm: PlaygroundViewModel?
    @FocusState private var inputFocused: Bool

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let vm {
                    header(vm)
                    terminal(vm)
                    explainCard(vm)
                    columns(vm)
                    branchesRow(vm)
                    recentCommitsRow(vm)
                    suggestionChips(vm)
                }
            }
            .padding(16)
        }
        .background(GQColor.bg.ignoresSafeArea())
        .navigationTitle(vm?.route.label ?? GQGeneratedContent.shared.shell.appTitle)
        .onAppear {
            if vm == nil { vm = PlaygroundViewModel(gitState: gitState) }
        }
    }

    private func header(_ vm: PlaygroundViewModel) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(vm.route.title).font(GQFont.display(22)).foregroundStyle(GQColor.cream)
                Text(vm.route.subtitle).font(GQFont.hand(13)).foregroundStyle(GQColor.muted3)
            }
            Spacer()
            Button(vm.copy.resetButton) { Task { await vm.reset() } }
                .buttonStyle(.gqPink)
        }
    }

    private func terminal(_ vm: PlaygroundViewModel) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 4) {
                        ForEach(vm.state?.output ?? []) { line in
                            Text(line.t)
                                .font(GQFont.mono(12))
                                .foregroundStyle(colorFor(line.k))
                                .id(line.id)
                        }
                        Color.clear.frame(height: 1).id("bottom")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(height: 180)
                .onChange(of: vm.state?.output.count) { _, _ in
                    withAnimation { proxy.scrollTo("bottom", anchor: .bottom) }
                }
            }

            HStack {
                Text("$").font(GQFont.mono(13)).foregroundStyle(GQColor.mint)
                TextField(vm.copy.inputPlaceholder, text: Binding(get: { vm.command }, set: { vm.command = $0 }))
                    .font(GQFont.mono(13))
                    .foregroundStyle(.white)
                    .focused($inputFocused)
                    .submitLabel(.go)
                    .onSubmit { Task { await vm.runInput() } }
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
            }
            .padding(10)
            .background(GQColor.panel3)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        }
        .padding(12)
        .background(GQColor.panel2)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).stroke(GQColor.ink, lineWidth: 2.5))
    }

    private func colorFor(_ k: String) -> Color {
        switch k {
        case "ok": return GQColor.mint
        case "err": return GQColor.pink
        case "dim": return GQColor.muted2
        case "sys": return GQColor.cyan
        default: return .white
        }
    }

    private func explainCard(_ vm: PlaygroundViewModel) -> some View {
        let title = vm.state?.explain.title ?? vm.copy.defaultExplainTitle
        let body = vm.state?.explain.body ?? vm.copy.defaultExplainBody
        return VStack(alignment: .leading, spacing: 3) {
            Text(title).font(GQFont.display(14))
            Text(body).font(GQFont.body(12)).foregroundStyle(GQColor.textOnCream.opacity(0.8))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(GQColor.cream)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous).stroke(GQColor.ink, lineWidth: 2))
    }

    private func columns(_ vm: PlaygroundViewModel) -> some View {
        HStack(spacing: 10) {
            ForEach(vm.columns) { item in
                column(title: item.title, subtitle: item.subtitle, color: colorForToken(item.color))
            }
        }
    }

    private func column(title: String, subtitle: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Circle().fill(color).frame(width: 10, height: 10)
            Text(title).font(GQFont.body(12, weight: .bold))
            Text(subtitle).font(GQFont.body(11)).foregroundStyle(GQColor.textOnCream.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(GQColor.cream)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).stroke(GQColor.ink, lineWidth: 2))
    }

    private func branchesRow(_ vm: PlaygroundViewModel) -> some View {
        Group {
            if !vm.branchPills.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(vm.branchPills) { pill in
                            Text(pill.isHead ? "⚑ \(pill.name)" : pill.name)
                                .font(GQFont.mono(11))
                                .padding(.horizontal, 10).padding(.vertical, 6)
                                .background(pill.isHead ? GQColor.mint : GQColor.cream)
                                .clipShape(Capsule())
                                .overlay(Capsule().stroke(GQColor.ink, lineWidth: 2))
                        }
                    }
                }
            }
        }
    }

    private func recentCommitsRow(_ vm: PlaygroundViewModel) -> some View {
        let grads: [[Color]] = [[GQColor.mint, Color(hex: "#2FBF7D")], [GQColor.purple, Color(hex: "#7452E0")], [GQColor.cyan, Color(hex: "#20A9B8")]]
        return Group {
            if !vm.recentCommits.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(vm.recentCommits) { commit in
                            VStack(spacing: 2) {
                                Text(commit.isHead ? "⚑" : " ").font(.caption2)
                                Text(commit.sha).font(GQFont.mono(10))
                            }
                            .padding(8)
                            .background(
                                LinearGradient(colors: grads[commit.gradientIndex], startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                        }
                    }
                }
            }
        }
    }

    private func suggestionChips(_ vm: PlaygroundViewModel) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(vm.copy.suggestionHeading).font(GQFont.body(12, weight: .bold)).foregroundStyle(GQColor.muted3)
            ForEach(vm.suggestions) { suggestion in
                Button {
                    vm.command = suggestion.cmd
                    inputFocused = true
                } label: {
                    HStack {
                        Text(suggestion.cmd).font(GQFont.mono(12))
                        Spacer()
                        Text(suggestion.hint).font(GQFont.body(10)).foregroundStyle(GQColor.textOnCream.opacity(0.6))
                    }
                }
                .buttonStyle(.gqDefault)
            }
        }
    }

    private func colorForToken(_ token: String) -> Color {
        switch token {
        case "gold": return GQColor.gold
        case "mint": return GQColor.mint
        default: return GQColor.orange
        }
    }
}
