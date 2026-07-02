import SwiftUI

struct GithubView: View {
    @Environment(GithubViewModel.self) private var vm

    var body: some View {
        @Bindable var vm = vm
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("GitHub Visualizer").font(GQFont.display(22)).foregroundStyle(GQColor.cream)
                Text("turn a profile into a quest log").font(GQFont.hand(13)).foregroundStyle(GQColor.muted3)

                HStack {
                    TextField("github username", text: $vm.username)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .padding(10)
                        .background(GQColor.cream)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .onSubmit { Task { await vm.submit() } }
                    Button("Scan") { Task { await vm.submit() } }.buttonStyle(.gqPrimary)
                }
                Button("Try demo") { vm.loadDemo() }.buttonStyle(.gqDefault)

                switch vm.status {
                case .empty:
                    EmptyView()
                case .loading:
                    ProgressView().tint(.white).frame(maxWidth: .infinity).padding()
                case .error:
                    VStack(spacing: 8) {
                        Text(vm.errorMessage).font(GQFont.body(13)).foregroundStyle(GQColor.pink)
                        Button("Try demo instead") { vm.loadDemo() }.buttonStyle(.gqPink)
                    }
                case .loaded:
                    if let data = vm.data, let derived = vm.derived {
                        loadedContent(data: data, derived: derived)
                    }
                }
            }
            .padding(16)
        }
        .background(GQColor.bg.ignoresSafeArea())
        .navigationTitle("GitHub")
    }

    private func loadedContent(data: GithubBundle, derived: DerivedGithub) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            profileHeader(data)
            statsGrid(data, derived)
            heatmap(derived)
            languageBars(derived)
            topRepos(derived)
            recentActivity(derived)
        }
    }

    private func profileHeader(_ data: GithubBundle) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(data.user.name ?? data.user.login).font(GQFont.display(18))
            Text("@\(data.user.login)").font(GQFont.mono(12)).foregroundStyle(GQColor.textOnCream.opacity(0.7))
            if let bio = data.user.bio { Text(bio).font(GQFont.body(12)) }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(GQColor.cream)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).stroke(GQColor.ink, lineWidth: 2.5))
    }

    private func statsGrid(_ data: GithubBundle, _ derived: DerivedGithub) -> some View {
        let items: [(String, String, Int)] = [
            ("Contributions", "XP", derived.totalContributions),
            ("Current streak", "Combo", derived.currentStreak),
            ("Repositories", "Worlds", data.user.public_repos),
            ("Languages", "Power types", derived.languages.count),
            ("Pull requests", "Missions", data.events.filter { $0.type == "PullRequestEvent" }.count),
            ("Stars", "Reputation", derived.totalStars),
        ]
        let columns = [GridItem(.adaptive(minimum: 100), spacing: 8)]
        return LazyVGrid(columns: columns, spacing: 8) {
            ForEach(items, id: \.0) { label, sub, value in
                VStack(spacing: 2) {
                    Text("\(value)").font(GQFont.display(16))
                    Text(label).font(GQFont.body(10, weight: .bold))
                    Text(sub).font(GQFont.body(9)).foregroundStyle(GQColor.textOnCream.opacity(0.6))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(GQColor.cream)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).stroke(GQColor.ink, lineWidth: 2))
            }
        }
    }

    private func heatmap(_ derived: DerivedGithub) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Contribution heatmap").font(GQFont.body(12, weight: .bold)).foregroundStyle(GQColor.cream)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 3) {
                    ForEach(Array(derived.weeks.enumerated()), id: \.0) { _, week in
                        VStack(spacing: 3) {
                            ForEach(week, id: \.date) { cell in
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(cell.uiColor)
                                    .frame(width: 10, height: 10)
                            }
                        }
                    }
                }
            }
        }
    }

    private func languageBars(_ derived: DerivedGithub) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Languages").font(GQFont.body(12, weight: .bold)).foregroundStyle(GQColor.cream)
            ForEach(derived.languages, id: \.name) { lang in
                VStack(alignment: .leading, spacing: 3) {
                    HStack { Text(lang.name).font(GQFont.body(11)); Spacer(); Text("\(lang.pct)%").font(GQFont.body(11)) }
                        .foregroundStyle(GQColor.cream)
                    GeometryReader { geo in
                        RoundedRectangle(cornerRadius: 4)
                            .fill(GQColor.mint)
                            .frame(width: geo.size.width * CGFloat(lang.pct) / 100, height: 6)
                    }
                    .frame(height: 6)
                    .background(GQColor.panel2)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                }
            }
        }
    }

    private func topRepos(_ derived: DerivedGithub) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Top repos").font(GQFont.body(12, weight: .bold)).foregroundStyle(GQColor.cream)
            ForEach(derived.topRepos, id: \.name) { repo in
                HStack {
                    Text(repo.name).font(GQFont.mono(12))
                    Spacer()
                    Text("★ \(repo.stars)").font(GQFont.body(11))
                }
                .padding(10)
                .background(GQColor.cream)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(GQColor.ink, lineWidth: 1.5))
            }
        }
    }

    private func recentActivity(_ derived: DerivedGithub) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Recent activity").font(GQFont.body(12, weight: .bold)).foregroundStyle(GQColor.cream)
            ForEach(derived.recent) { item in
                HStack {
                    Text(item.icon)
                    Text(item.text).font(GQFont.body(12)).foregroundStyle(GQColor.cream)
                    Spacer()
                    Text(item.when).font(GQFont.body(10)).foregroundStyle(GQColor.muted3)
                }
            }
        }
    }
}
