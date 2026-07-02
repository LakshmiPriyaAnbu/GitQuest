import SwiftUI

struct CommitMapCanvas: View {
    let nodes: [MapNode]
    let edges: [MapEdge]
    let size: CGSize
    let selectedId: String?
    let onTap: (String) -> Void

    private let nodeRadius: CGFloat = 12

    var body: some View {
        Canvas { context, _ in
            for edge in edges {
                var path = Path()
                path.move(to: edge.from)
                let c1 = CGPoint(x: edge.from.x + 46, y: edge.from.y)
                let c2 = CGPoint(x: edge.to.x - 46, y: edge.to.y)
                path.addCurve(to: edge.to, control1: c1, control2: c2)
                context.stroke(path, with: .color(edge.color), lineWidth: 3)
            }

            for node in nodes {
                let rect = CGRect(x: node.x - nodeRadius, y: node.y - nodeRadius, width: nodeRadius * 2, height: nodeRadius * 2)
                let circle = Path(ellipseIn: rect)
                context.fill(circle, with: .color(node.color))
                context.stroke(circle, with: .color(GQColor.ink), lineWidth: node.id == selectedId ? 3.5 : 2)

                if node.isMerge {
                    let dot = Path(ellipseIn: CGRect(x: node.x - 3, y: node.y - 3, width: 6, height: 6))
                    context.fill(dot, with: .color(.white))
                }
                if node.isHead {
                    var flag = Path()
                    flag.move(to: CGPoint(x: node.x, y: node.y - nodeRadius - 2))
                    flag.addLine(to: CGPoint(x: node.x, y: node.y - nodeRadius - 16))
                    flag.addLine(to: CGPoint(x: node.x + 10, y: node.y - nodeRadius - 12))
                    flag.addLine(to: CGPoint(x: node.x, y: node.y - nodeRadius - 8))
                    context.fill(flag, with: .color(GQColor.gold))
                }

                context.draw(
                    Text(String(node.id.prefix(4))).font(.system(size: 9, design: .monospaced)).foregroundStyle(.white.opacity(0.8)),
                    at: CGPoint(x: node.x, y: node.y + nodeRadius + 9)
                )
            }
        }
        .frame(width: size.width, height: size.height)
        .gesture(
            SpatialTapGesture().onEnded { value in
                if let hit = nodes.min(by: { distance($0, value.location) < distance($1, value.location) }),
                   distance(hit, value.location) < 24 {
                    onTap(hit.id)
                }
            }
        )
    }

    private func distance(_ node: MapNode, _ point: CGPoint) -> CGFloat {
        let dx = node.x - point.x
        let dy = node.y - point.y
        return (dx * dx + dy * dy).squareRoot()
    }
}
