import SwiftUI

struct ConflictModalView: View {
    let conflict: GitConflict
    let onResolve: (ConflictChoice) -> Void
    let onCancel: () -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("⚔️ Merge conflict!").font(GQFont.display(20))
                    Text(conflict.file).font(GQFont.mono(13)).foregroundStyle(GQColor.textOnCream.opacity(0.7))
                }

                diffPane(title: "CURRENT", lines: conflict.ours, color: GQColor.mint)
                diffPane(title: "INCOMING", lines: conflict.theirs, color: GQColor.pink)

                VStack(spacing: 10) {
                    Button("Keep current") { onResolve(.current) }.buttonStyle(.gqPrimary).frame(maxWidth: .infinity)
                    Button("Keep incoming") { onResolve(.incoming) }.buttonStyle(.gqPink).frame(maxWidth: .infinity)
                    Button("Combine both") { onResolve(.both) }.buttonStyle(.gqCyan).frame(maxWidth: .infinity)
                    Button("Cancel", role: .cancel) { onCancel() }.buttonStyle(.gqDefault).frame(maxWidth: .infinity)
                }
            }
            .padding(20)
        }
        .background(GQColor.bg.ignoresSafeArea())
    }

    private func diffPane(title: String, lines: [String], color: Color) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title).font(GQFont.body(11, weight: .bold)).foregroundStyle(color)
            VStack(alignment: .leading, spacing: 2) {
                ForEach(lines, id: \.self) { line in
                    Text(line).font(GQFont.mono(11))
                }
            }
            .padding(10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(GQColor.panel2)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(color, lineWidth: 2))
        }
    }
}
