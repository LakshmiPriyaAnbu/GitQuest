import SwiftUI

struct BadgeChipView: View {
    let badge: BadgeDef
    let unlocked: Bool

    var body: some View {
        VStack(spacing: 6) {
            Text(badge.emoji)
                .font(.system(size: 30))
                .grayscale(unlocked ? 0 : 1)
                .opacity(unlocked ? 1 : 0.35)
            Text(badge.title)
                .font(GQFont.body(11, weight: .bold))
                .multilineTextAlignment(.center)
                .lineLimit(2)
            if !unlocked {
                Text(badge.hint)
                    .font(GQFont.body(9))
                    .foregroundStyle(GQColor.textOnCream.opacity(0.55))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(10)
        .background(unlocked ? GQColor.cream : GQColor.cream.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(GQColor.ink, lineWidth: 2)
        )
    }
}
