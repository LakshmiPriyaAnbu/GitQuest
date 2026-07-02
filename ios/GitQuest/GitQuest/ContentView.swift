import SwiftUI

struct ContentView: View {
    @Environment(GameStateStore.self) private var game
    @Environment(AppRouter.self) private var router

    var body: some View {
        @Bindable var router = router
        ZStack(alignment: .top) {
            TabView(selection: $router.tab) {
                NavigationStack {
                    DashboardView()
                }
                .tabItem { Label("Home", systemImage: GQIcon.symbol(for: "home")) }
                .tag(AppTab.dashboard)

                NavigationStack {
                    PlaygroundView()
                }
                .tabItem { Label("Play", systemImage: GQIcon.symbol(for: "play")) }
                .tag(AppTab.playground)

                NavigationStack {
                    CommitMapView()
                }
                .tabItem { Label("Map", systemImage: GQIcon.symbol(for: "map")) }
                .tag(AppTab.commitMap)

                NavigationStack {
                    GithubView()
                }
                .tabItem { Label("GitHub", systemImage: GQIcon.symbol(for: "github")) }
                .tag(AppTab.github)

                NavigationStack(path: $router.morePath) {
                    MoreView()
                }
                .tabItem { Label("More", systemImage: "ellipsis.circle.fill") }
                .tag(AppTab.more)
            }
            .tint(GQColor.mint)

            ToastOverlay(toasts: game.toasts)
        }
    }
}
