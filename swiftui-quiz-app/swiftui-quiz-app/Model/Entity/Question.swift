//
//  Question.swift
//  swiftui-quiz-app
//
//  Created by Andressa Valengo on 20/02/21.
//

import Foundation

struct Question: Hashable {
    let category: CategoryType
    let difficulty: Difficulty
    let question, correctAnswer: String
    let incorrectAnswers: [String]
}
