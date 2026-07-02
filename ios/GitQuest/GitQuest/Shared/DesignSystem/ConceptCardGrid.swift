import SwiftUI

struct ConceptCard: Identifiable, Hashable {
    let emoji: String
    let title: String
    let meta: String
    let body: String
    let accent: String

    var id: String { title }
    var accentColor: Color { Color(hex: accent) }
}

/// Shared read-only glossary grid used by both the Internals and Learn screens —
/// they render the same card shape, just with different content.
struct ConceptCardGrid: View {
    let title: String
    let subtitle: String
    let cards: [ConceptCard]

    private let columns = [GridItem(.adaptive(minimum: 160), spacing: 14)]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title).font(GQFont.display(26)).foregroundStyle(GQColor.cream)
                    Text(subtitle).font(GQFont.hand(15)).foregroundStyle(GQColor.muted3)
                }

                LazyVGrid(columns: columns, spacing: 14) {
                    ForEach(cards) { card in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(card.emoji).font(.system(size: 32))
                            Text(card.title).font(GQFont.display(16))
                            Text(card.meta.uppercased())
                                .font(GQFont.body(11, weight: .bold))
                                .foregroundStyle(card.accentColor)
                            Text(card.body)
                                .font(GQFont.body(13))
                                .foregroundStyle(GQColor.textOnCream.opacity(0.85))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(14)
                        .background(GQColor.cream)
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .stroke(GQColor.ink, lineWidth: 2.5)
                        )
                    }
                }
            }
            .padding(16)
        }
        .background(GQColor.bg.ignoresSafeArea())
    }
}
