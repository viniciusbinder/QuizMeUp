//
//  QuestionDataViewModel.swift
//  swiftui-quiz-app
//
//  Created by Andressa Valengo on 20/02/21.
//

import Foundation
import Combine

class QuestionDataViewModel: ObservableObject {
    
    struct QuestionViewModel {
        let category: CategoryType
        let difficulty: Difficulty
        let question: String
        let answers: [String]
        let correctAnswer: String
        
        init(data: Question) {
            self.category = data.category
            self.difficulty = data.difficulty
            self.question = data.question
            self.answers = (data.incorrectAnswers + [data.correctAnswer]).shuffled()
            self.correctAnswer = data.correctAnswer
        }
    }
    
    @Published var data: [QuestionViewModel] = []
    @Published var state: State = .idle
    
    private var bag = Set<AnyCancellable>()
    private let input = PassthroughSubject<Event, Never>()
    
    private let service: TriviaServiceProtocol

    init(service: TriviaServiceProtocol = OpenTriviaDatabase()) {
        self.service = service
    }
    
    func send(event: QuestionDataViewModel.Event) {
        input.send(event)
    }
    
    func load(for categoryId: Int, with difficulty: Difficulty) {
        state = .loading
        self.service.getQuestions(withCategory: categoryId, difficulty: difficulty.rawValue, max: 10)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .failure(let error):
                    self?.state = .error
                    print("Error while loading questions -> \(error)")
                case .finished:
                    print("Loaded questions for categoryId=\(categoryId)")
                }
            }, receiveValue: { [weak self] questions in
                self?.data = questions.map { QuestionViewModel(data: $0) }
                self?.state = questions.isEmpty ? .noData : .loaded
            }).store(in: &bag)
    }
}

extension QuestionDataViewModel {
    enum State {
        case idle
        case loading
        case loaded
        case error
        case noData
        
//        func nextState(for event: Event) -> State {
//            switch self {
//            case .idle:
//                return self
//            case .loading:
//                <#code#>
//            case .loaded:
//                <#code#>
//            case .error:
//                <#code#>
//            case .noData:
//                <#code#>
//            }
//        }
    }
    
    enum Event {
        case onAppear
        case onLoad(Int, String)
        case onLoaded([Question])
        case onFailedToLoad(Error)
    }
    
}
