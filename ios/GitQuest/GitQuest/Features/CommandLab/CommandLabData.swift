import Foundation

struct QuizOption: Hashable {
    let t: String
    let correct: Bool
}

struct Quiz: Hashable {
    let q: String
    let options: [QuizOption]
}

struct Lesson: Identifiable, Hashable {
    let id: String
    let cmd: String
    let blurb: String
    let syntax: String
    let example: String
    let from: String
    let to: String
    let file: String
    let mistakes: [String]
    let quiz: Quiz
}
