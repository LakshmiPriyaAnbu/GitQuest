import SwiftUI

@main
struct GitQuestApp: App {
    @State private var game: GameStateStore
    @State private var gitState: GitStateController
    @State private var github: GithubViewModel
    @State private var router = AppRouter()

    init() {
        let game = GameStateStore()
        _game = State(initialValue: game)
        _gitState = State(initialValue: GitStateController(game: game))
        _github = State(initialValue: GithubViewModel(game: game))
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(game)
                .environment(gitState)
                .environment(github)
                .environment(router)
                .preferredColorScheme(.dark)
                .task { await gitState.refresh() }
        }
    }
}
