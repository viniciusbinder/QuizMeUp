//
//  Enums.swift
//  swiftui-quiz-app
//
//  Created by Andressa Valengo on 20/02/21.
//

import Foundation

enum Difficulty: String {
    case easy
    case medium
    case hard
    
    static func from(int: Int) -> Self {
        switch int {
        case 1: return .medium
        case 2: return .hard
        default: return .easy
        }
    }
    
    var multiplier: Int {
        switch self {
        case .easy:
            return 10
        case .medium:
            return 20
        case .hard:
            return 30
        }
    }
}

enum CategoryType: String, CaseIterable {
    case random = "Random"
    case art = "Art"
    case generalKnowledge = "General Knowledge"
    case geography = "Geography"
    case history = "History"
    case mythology = "Mythology"
    case scienceAndNature = "Science & Nature"
    
    
    var id: Int {
        switch self {
        case .random: return [9, 22, 23, 20, 17].randomElement() ?? 17
        case .art: return 25
        case .generalKnowledge: return 9
        case .geography: return 22
        case .history: return 23
        case .mythology: return 20
        case .scienceAndNature: return 17
        }
    }
    
    var emoji: String {
        switch self {
        case .random: return "🎁"
        case .art: return "🎨"
        case .generalKnowledge: return "🦉"
        case .geography: return "🏝"
        case .history: return "🏛"
        case .mythology: return "🏺"
        case .scienceAndNature: return "🌺"
        }
    }
}

enum AnswerCode: String {
    case A, B, C, D
    
    static func getCode(for index: Int) -> AnswerCode {
        switch index {
        case 0: return .A
        case 1: return .B
        case 2: return .C
        default: return .D
        }
    }
}
