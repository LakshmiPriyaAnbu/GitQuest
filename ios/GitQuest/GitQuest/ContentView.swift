import SwiftUI

struct ContentView: View {
    @Environment(GameStateStore.self) private var game
    @Environment(AppRouter.self) private var router

    var body: some View {
        let _ = game.settings.theme
        @Bindable var router = router
        ZStack(alignment: .top) {
            TabView(selection: $router.tab) {
                NavigationStack {
                    DashboardView()
                }
                .tabItem { Label(route("dashboard")?.tabLabel ?? "Home", systemImage: GQIcon.symbol(for: "home")) }
                .tag(AppTab.dashboard)

                NavigationStack {
                    PlaygroundView()
                }
                .tabItem { Label(route("playground")?.tabLabel ?? "Play", systemImage: GQIcon.symbol(for: "play")) }
                .tag(AppTab.playground)

                NavigationStack {
                    CommitMapView()
                }
                .tabItem { Label(route("commitmap")?.tabLabel ?? "Map", systemImage: GQIcon.symbol(for: "map")) }
                .tag(AppTab.commitMap)

                NavigationStack {
                    GithubView()
                }
                .tabItem { Label(route("github")?.tabLabel ?? "GitHub", systemImage: GQIcon.symbol(for: "github")) }
                .tag(AppTab.github)

                NavigationStack(path: $router.morePath) {
                    MoreView()
                }
                .tabItem { Label(GQGeneratedContent.shared.shell.moreTitle, systemImage: "ellipsis.circle.fill") }
                .tag(AppTab.more)
            }
            .tint(GQColor.mint)

            ToastOverlay(toasts: game.toasts)
        }
    }

    private func route(_ id: String) -> AppRouteDescriptor? {
        APP_ROUTES.first(where: { $0.id == id })
    }
}
