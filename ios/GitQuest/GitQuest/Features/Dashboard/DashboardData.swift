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

let FEATURES: [FeatureCard] = [
    FeatureCard(icon: "play", iconBg: "#43E197", title: "Git Playground", body: "Type real commands and watch your files move between camp, backpack, and commits.", route: "/playground"),
    FeatureCard(icon: "lab", iconBg: "#FFC24B", title: "Command Lab", body: "Learn one git spell at a time, with a quiz to prove you've got it.", route: "/commandlab"),
    FeatureCard(icon: "map", iconBg: "#9B7CFF", title: "Commit Map", body: "See your whole history as a branching quest map you can click through.", route: "/commitmap"),
    FeatureCard(icon: "branch", iconBg: "#37D6E6", title: "Branch & Merge", body: "Fork a path, fight a merge conflict, and bring it all back together.", route: "/branches"),
    FeatureCard(icon: "quest", iconBg: "#FF6B9D", title: "Quests", body: "A guided path of 8 quests that takes you from init to your first merge.", route: "/quests"),
]
