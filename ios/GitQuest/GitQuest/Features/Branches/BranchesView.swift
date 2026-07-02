import SwiftUI

struct BranchesView: View {
    @Environment(GitStateController.self) private var gitState
    @State private var vm: BranchesViewModel?

    var body: some View {
        Group {
            if let vm {
                content(vm)
                    .sheet(isPresented: Binding(get: { vm.conflict != nil }, set: { if !$0 { Task { await vm.cancelConflict() } } })) {
                        if let conflict = vm.conflict {
                            ConflictModalView(conflict: conflict) { choice in
                                Task { await vm.resolve(choice) }
                            } onCancel: {
                                Task { await vm.cancelConflict() }
                            }
                        }
                    }
            } else {
                // The else branch matters: an empty Group renders nothing, so
                // .onAppear never fires and vm would never be created.
                Color.clear
            }
        }
        .background(GQColor.bg.ignoresSafeArea())
        .navigationTitle("Branch & Merge")
        .onAppear { if vm == nil { vm = BranchesViewModel(gitState: gitState) } }
    }

    private func content(_ vm: BranchesViewModel) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Branch & Merge").font(GQFont.display(22)).foregroundStyle(GQColor.cream)
                Text("fork paths and bring them back together").font(GQFont.hand(13)).foregroundStyle(GQColor.muted3)

                actionsRow(vm)
                explainerCards()

                Text("Branches").font(GQFont.body(13, weight: .bold)).foregroundStyle(GQColor.cream)
                ForEach(vm.branches) { branch in
                    branchRow(vm, branch)
                }
            }
            .padding(16)
        }
    }

    private func actionsRow(_ vm: BranchesViewModel) -> some View {
        VStack(spacing: 10) {
            Button("Create + switch branch") { Task { await vm.newBranch() } }
                .buttonStyle(.gqPrimary).frame(maxWidth: .infinity)
            Button("Commit here") { Task { await vm.commitHere() } }
                .buttonStyle(.gqCyan).frame(maxWidth: .infinity)
            Button("Merge into main") { Task { await vm.mergeMain() } }
                .buttonStyle(.gqPurple).frame(maxWidth: .infinity)
            Button("Conflict battle ⚔️") { Task { await vm.startConflict() } }
                .buttonStyle(.gqPink).frame(maxWidth: .infinity)
        }
    }

    private func branchRow(_ vm: BranchesViewModel, _ branch: BranchRow) -> some View {
        HStack {
            Image(systemName: "arrow.triangle.branch")
            VStack(alignment: .leading, spacing: 1) {
                Text(branch.name).font(GQFont.mono(13)).fontWeight(branch.isHead ? .bold : .regular)
                Text(branch.tip).font(GQFont.mono(10)).foregroundStyle(GQColor.textOnCream.opacity(0.6))
            }
            Spacer()
            if branch.isHead {
                Text("HEAD").font(GQFont.body(10, weight: .bold)).padding(4).background(GQColor.mint).clipShape(Capsule())
            } else {
                Button("Switch") { Task { await vm.switchTo(branch.name) } }.buttonStyle(.gqDefault)
            }
        }
        .padding(12)
        .background(GQColor.cream)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous).stroke(GQColor.ink, lineWidth: 2))
    }

    private func explainerCards() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            explainerCard(title: "Fast-forward merge", body: "When main hasn't moved since you branched, merging just slides main's pointer forward — no new commit needed.")
            explainerCard(title: "Three-way merge", body: "When both branches have new commits, Git weaves them together into a new merge commit with two parents.")
            explainerCard(title: "Conflict", body: "If both branches changed the same lines, Git can't guess which one wins — you resolve it by hand.")
        }
    }

    private func explainerCard(title: String, body: String) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(title).font(GQFont.body(12, weight: .bold))
            Text(body).font(GQFont.body(11)).foregroundStyle(GQColor.textOnCream.opacity(0.75))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(GQColor.cream.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).stroke(GQColor.ink, lineWidth: 1.5))
    }
}
