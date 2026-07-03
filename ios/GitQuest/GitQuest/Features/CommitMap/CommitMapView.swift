import SwiftUI

struct CommitMapView: View {
    @Environment(GitStateController.self) private var gitState
    @Environment(GameStateStore.self) private var game
    @Environment(AppRouter.self) private var router
    @State private var vm: CommitMapViewModel?

    var body: some View {
        Group {
            // The else branch matters: an empty Group renders nothing, so
            // .onAppear never fires and vm would never be created.
            if let vm {
                content(vm)
            } else {
                Color.clear
            }
        }
        .background(GQColor.bg.ignoresSafeArea())
        .navigationTitle(vm?.route.label ?? GQGeneratedContent.shared.shell.appTitle)
        .onAppear { if vm == nil { vm = CommitMapViewModel(gitState: gitState, game: game, router: router) } }
    }

    private func content(_ vm: CommitMapViewModel) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(vm.route.title).font(GQFont.display(22)).foregroundStyle(GQColor.cream)
                Text(vm.route.subtitle).font(GQFont.hand(13)).foregroundStyle(GQColor.muted3)

                if !vm.hasCommits {
                    emptyState(vm)
                } else {
                    legendRow(vm)

                    ScrollView(.horizontal) {
                        CommitMapCanvas(nodes: vm.nodes, edges: vm.edges, size: vm.mapSize, selectedId: vm.selectedId) { id in
                            vm.select(id)
                        }
                        .padding(8)
                    }
                    .background(GQColor.panel2)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).stroke(GQColor.ink, lineWidth: 2.5))

                    if let commit = vm.selectedCommit {
                        detailPanel(vm, commit)
                    }
                }
            }
            .padding(16)
        }
    }

    private func emptyState(_ vm: CommitMapViewModel) -> some View {
        VStack(spacing: 12) {
            Text(vm.copy.emptyTitle)
                .font(GQFont.display(16))
                .foregroundStyle(GQColor.textOnCream)
            Text(vm.copy.emptyBody)
                .font(GQFont.body(14))
                .foregroundStyle(GQColor.textOnCream)
                .multilineTextAlignment(.center)
            Button(vm.copy.openPlaygroundButton) { vm.openPlayground() }
                .buttonStyle(.gqPrimary)
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(GQColor.cream)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous).stroke(GQColor.ink, lineWidth: 2.5))
    }

    private func legendRow(_ vm: CommitMapViewModel) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(vm.legend) { entry in
                    HStack(spacing: 5) {
                        Circle().fill(entry.color).frame(width: 9, height: 9)
                        Text(entry.name).font(GQFont.mono(11)).foregroundStyle(GQColor.cream)
                    }
                }
            }
        }
    }

    private func detailPanel(_ vm: CommitMapViewModel, _ commit: Commit) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(commit.msg).font(GQFont.display(15))
            Text(commit.id).font(GQFont.mono(11)).foregroundStyle(GQColor.textOnCream.opacity(0.6))
            Text("\(vm.copy.detailLabels.author): \(commit.author) · \(vm.copy.detailBranchPrefix)\(commit.branch)").font(GQFont.body(12))
            Text("\(vm.copy.detailLabels.parents): \(commit.parents.isEmpty ? vm.copy.detailLabels.rootCommit : commit.parents.joined(separator: ", "))").font(GQFont.mono(11))
            if !commit.files.isEmpty {
                Text("\(vm.copy.detailLabels.changedFiles): \(commit.files.joined(separator: ", "))").font(GQFont.body(12))
            }
            Text("\(vm.copy.detailLabels.time): \(vm.formatTime(commit))").font(GQFont.body(11)).foregroundStyle(GQColor.textOnCream.opacity(0.6))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(GQColor.cream)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).stroke(GQColor.ink, lineWidth: 2.5))
    }
}
