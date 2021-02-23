//
//  Mocks.swift
//  swiftui-quiz-app
//
//  Created by Andressa Valengo on 20/02/21.
//

import Foundation

final class Mocks {
    static let data: [Question] = [
        Question(category: .mythology, difficulty: .easy,
                 question: "Who was the only god from Greece who did not get a name change in Rome?",
                 correctAnswer: "Apollo", incorrectAnswers: ["Demeter", "Zeus", "Athena"]),
        Question(category: .mythology, difficulty: .easy,
                 question: "Who in Greek mythology, who led the Argonauts in search of the Golden Fleece?",
                 correctAnswer: "Jason", incorrectAnswers: ["Castor", "Daedalus", "Odysseus"]),
        Question(category: .mythology, difficulty: .easy,
                 question: "Who was the King of Gods in Ancient Greek mythology?",
                 correctAnswer: "Zeus", incorrectAnswers: ["Apollo", "Hermes", "Poseidon"]),
        Question(category: .mythology, difficulty: .easy,
                 question: "Which Greek & Roman god was known as the god of music, truth and prophecy, healing, the sun and light, plague, poetry, and more?",
                 correctAnswer: "Apollo", incorrectAnswers: ["Aphrodite", "Artemis", "Athena"]),
        Question(category: .mythology, difficulty: .easy,
                 question: "The greek god Poseidon was the god of what?",
                 correctAnswer: "The Sea", incorrectAnswers: ["War", "Sun", "Fire"])
        
    ]
}
