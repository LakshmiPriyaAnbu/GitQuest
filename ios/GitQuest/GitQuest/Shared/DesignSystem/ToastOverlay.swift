import SwiftUI

struct ToastOverlay: View {
    let toasts: [GameToast]

    var body: some View {
        VStack(spacing: 8) {
            ForEach(toasts) { toast in
                HStack(spacing: 10) {
                    Text(icon(for: toast.kind)).font(.system(size: 22))
                    VStack(alignment: .leading, spacing: 1) {
                        Text(toast.title).font(GQFont.display(14))
                        Text(toast.body).font(GQFont.body(12)).foregroundStyle(GQColor.textOnCream.opacity(0.75))
                    }
                    Spacer(minLength: 0)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .frame(maxWidth: 340)
                .background(background(for: toast.kind))
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(GQColor.ink, lineWidth: 2.5)
                )
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .animation(.spring(duration: 0.3), value: toasts)
        .padding(.top, 8)
    }

    private func icon(for kind: GameToast.Kind) -> String {
        switch kind {
        case .xp: return "⚡️"
        case .badge: return "🏅"
        case .info: return "ℹ️"
        }
    }

    private func background(for kind: GameToast.Kind) -> Color {
        switch kind {
        case .xp: return GQColor.mint
        case .badge: return GQColor.gold
        case .info: return GQColor.cream
        }
    }
}
