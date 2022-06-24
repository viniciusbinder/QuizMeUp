//
//  TriviaServiceProtocol.swift
//  swiftui-quiz-app
//
//  Created by Andressa Valengo on 20/02/21.
//

import Foundation
import Combine

enum APIError: Error, LocalizedError {
    case unknown, apiError(reason: String), parserError(reason: String), networkError(from: URLError)
    
    var errorDescription: String? {
        switch self {
        case .unknown:
            return "Unknown error"
        case .apiError(reason: let reason), .parserError(reason: let reason):
            return reason
        case .networkError(from: let from):
            return from.localizedDescription
        }
    }
}

protocol TriviaServiceProtocol {
    func getQuestions(withCategory categoryId: Int, difficulty: String, max: Int) -> AnyPublisher<[Question], Error>
}
