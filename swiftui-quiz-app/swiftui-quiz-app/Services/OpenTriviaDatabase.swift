//
//  OpenTriviaDatabaseService.swift
//  swiftui-quiz-app
//
//  Created by Andressa Valengo on 20/02/21.
//

import Foundation
import Combine


class OpenTriviaDatabase: TriviaServiceProtocol {
    
    private let host = "opentdb.com"
    private let path = "/api.php"

    func getQuestions(withCategory categoryId: Int, difficulty: String, max: Int) -> AnyPublisher<[Question], Error> {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = path
        components.queryItems =  [
            URLQueryItem(name: "category", value: "\(categoryId)"),
            URLQueryItem(name: "amount", value: "\(max)"),
            URLQueryItem(name: "type", value: "multiple"),
            URLQueryItem(name: "difficulty", value: difficulty)
        ]
        
        guard let url = components.url else {return Fail(error: APIError.parserError(reason: "Failed building request URL")).eraseToAnyPublisher()}
                
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: Response.self, decoder: JSONDecoder())
            .map { [unowned self] response in
                return response.results.map(questionDTO2Question(dto:))
            }
            .eraseToAnyPublisher()
    }
    
    private func questionDTO2Question(dto: QuestionDTO) -> Question {
        guard let category = CategoryType(rawValue: dto.category) else { preconditionFailure("Failed parsing category \(dto.category)") }
        guard let difficulty = Difficulty(rawValue: dto.difficulty) else { preconditionFailure("Failed parsing difficulty \(dto.difficulty)") }
        return Question(category: category,
                        difficulty: difficulty,
                        question: dto.question.html2String,
                        correctAnswer: dto.correct_answer.html2String,
                        incorrectAnswers: dto.incorrect_answers.map {$0.html2String})
    }
    
    // MARK: - Response
    struct Response: Decodable {
        let response_code: Int
        let results: [QuestionDTO]
    }

    // MARK: - QuestionDTO
    struct QuestionDTO: Decodable {
        let category: String
        let difficulty: String
        let type: String
        let question, correct_answer: String
        let incorrect_answers: [String]
    }
}

extension String {
    var data: Data { .init(utf8) }
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html,
                                                                .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            print(error)
            return nil
        }
    }
    var html2String: String { html2AttributedString?.string ?? "" }
    var unicodes: [UInt32] { unicodeScalars.map(\.value) }
}
