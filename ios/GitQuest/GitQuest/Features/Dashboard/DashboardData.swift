import SwiftUI

struct FeatureCard: Identifiable, Hashable {
    let icon: String
    let iconBg: String
    let title: String
    let body: String
    let route: String

    var id: String { route }
    var iconBgColor: Color { Color(hex: iconBg) }
}
