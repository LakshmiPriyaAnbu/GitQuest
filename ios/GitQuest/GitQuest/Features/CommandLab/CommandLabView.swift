import SwiftUI

struct CommandLabView: View {
    @Environment(GameStateStore.self) private var game
    @State private var vm: CommandLabViewModel?

    var body: some View {
        Group {
            // The else branch matters: an empty Group renders nothing, so
            // .onAppear never fires and vm would never be created.
            if let vm {
                content(vm)
            } else {
                Color.clear
            }
        }
        .background(GQColor.bg.ignoresSafeArea())
        .navigationTitle("Command Lab")
        .onAppear { if vm == nil { vm = CommandLabViewModel(game: game) } }
    }

    private func content(_ vm: CommandLabViewModel) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Command Lab").font(GQFont.display(22)).foregroundStyle(GQColor.cream)
                Text("learn one spell at a time").font(GQFont.hand(13)).foregroundStyle(GQColor.muted3)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(LESSONS) { lesson in
                            Button {
                                vm.select(lesson.id)
                            } label: {
                                Text(lesson.cmd)
                                    .font(GQFont.mono(12))
                                    .padding(.horizontal, 12).padding(.vertical, 8)
                                    .background(vm.activeId == lesson.id ? GQColor.gold : GQColor.cream)
                                    .clipShape(Capsule())
                                    .overlay(Capsule().stroke(GQColor.ink, lineWidth: 2))
                                    .overlay(alignment: .topTrailing) {
                                        if vm.quizDone[lesson.id] == true {
                                            Text("✓").font(.caption2).padding(3).background(GQColor.mint).clipShape(Circle())
                                        }
                                    }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                lessonCard(vm)
            }
            .padding(16)
        }
    }

    private func lessonCard(_ vm: CommandLabViewModel) -> some View {
        let lesson = vm.activeLesson
        return VStack(alignment: .leading, spacing: 12) {
            Text(lesson.blurb).font(GQFont.body(14)).foregroundStyle(GQColor.textOnCream)

            labeledMono("Syntax", lesson.syntax)
            labeledMono("Example", lesson.example)

            if !lesson.mistakes.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Common mistakes").font(GQFont.body(12, weight: .bold))
                    ForEach(lesson.mistakes, id: \.self) { mistake in
                        Text("• \(mistake)").font(GQFont.body(12)).foregroundStyle(GQColor.textOnCream.opacity(0.8))
                    }
                }
            }

            Divider()

            VStack(alignment: .leading, spacing: 8) {
                Text(lesson.quiz.q).font(GQFont.body(13, weight: .bold))
                ForEach(lesson.quiz.options, id: \.t) { option in
                    Button {
                        vm.pick(option)
                    } label: {
                        HStack {
                            Text(option.t).font(GQFont.body(13))
                            Spacer()
                            if vm.quizDone[lesson.id] == true && option.correct {
                                Text("✓")
                            } else if vm.wrongPick == option.t {
                                Text("✗")
                            }
                        }
                    }
                    .buttonStyle(.gqDefault)
                    .disabled(vm.quizDone[lesson.id] == true)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(GQColor.cream)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous).stroke(GQColor.ink, lineWidth: 2.5))
    }

    private func labeledMono(_ label: String, _ value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label.uppercased()).font(GQFont.body(10, weight: .bold)).foregroundStyle(GQColor.textOnCream.opacity(0.55))
            Text(value).font(GQFont.mono(12))
        }
    }
}
