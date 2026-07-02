import SwiftUI

struct InternalsView: View {
    var body: some View {
        ConceptCardGrid(title: "Git Internals", subtitle: "what git hides under the hood", cards: INTERNALS_CARDS)
            .navigationTitle("Git Internals")
    }
}
