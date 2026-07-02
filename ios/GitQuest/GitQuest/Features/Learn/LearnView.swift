import SwiftUI

struct LearnView: View {
    var body: some View {
        ConceptCardGrid(title: "Learn", subtitle: "plain-English git concepts", cards: LEARN_CARDS)
            .navigationTitle("Learn")
    }
}
