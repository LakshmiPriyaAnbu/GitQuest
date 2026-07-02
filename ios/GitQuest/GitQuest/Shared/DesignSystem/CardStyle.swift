import SwiftUI

/// Mirrors the `.gq-panel` cream-card-with-ink-border-and-offset-shadow look from styles.css.
struct GQCardStyle: ViewModifier {
    var padding: CGFloat = 16
    var dark: Bool = false

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(dark ? GQColor.panel1 : GQColor.cream)
            .foregroundStyle(dark ? GQColor.cream : GQColor.textOnCream)
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .stroke(GQColor.ink, lineWidth: 3)
            )
            .shadow(color: .clear, radius: 0)
            .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(GQColor.ink)
                    .offset(x: 5, y: 6)
            )
    }
}

extension View {
    func gqCard(padding: CGFloat = 16, dark: Bool = false) -> some View {
        modifier(GQCardStyle(padding: padding, dark: dark))
    }
}

/// Mirrors `.gq-btn` — a chunky bordered button with an offset "hand-drawn" shadow.
struct GQButtonStyle: ButtonStyle {
    var background: Color = GQColor.cream
    var foreground: Color = GQColor.textOnCream

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(GQFont.display(14))
            .padding(.horizontal, 18)
            .padding(.vertical, 11)
            .background(background)
            .foregroundStyle(foreground)
            .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 13, style: .continuous)
                    .stroke(GQColor.ink, lineWidth: 2.5)
            )
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == GQButtonStyle {
    static var gqPrimary: GQButtonStyle { GQButtonStyle(background: GQColor.mint, foreground: Color(hex: "#0B3A26")) }
    static var gqPurple: GQButtonStyle { GQButtonStyle(background: GQColor.purple, foreground: GQColor.cream) }
    static var gqCyan: GQButtonStyle { GQButtonStyle(background: GQColor.cyan, foreground: Color(hex: "#0B3A40")) }
    static var gqPink: GQButtonStyle { GQButtonStyle(background: GQColor.pink, foreground: GQColor.cream) }
    static var gqDefault: GQButtonStyle { GQButtonStyle() }
}
