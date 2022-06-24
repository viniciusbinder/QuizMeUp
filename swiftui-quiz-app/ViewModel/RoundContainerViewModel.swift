//
//  QuizViewModel.swift
//  swiftui-quiz-app
//
//  Created by Andressa Valengo on 20/02/21.
//

import Foundation
import Combine

struct QuizResultViewModel {
    let category: CategoryType
    let difficulty: Difficulty
    let numberOfQuestions: Int
    let correctAnswers: Int
    let points: Int
}

struct RoundConfiguration {
    let category: CategoryType
    let difficulty: Difficulty
}


class RoundContainerViewModel: ObservableObject {
    
    @Published private(set) var state: State = .idle

    
    let currentQuestion: CurrentValueSubject<QuestionDataViewModel.QuestionViewModel, Never>
    
    private let questions: [QuestionDataViewModel.QuestionViewModel]
    private let gcService = GameCenter.shared
    private let playerData = UserDefaults.standard
    private let configuration: RoundConfiguration
    private var currentQuestionIndex: Int = 0
    private var correctAnswerCounter = 0
    private(set) var totalPoints = 0
    
    init(data: [QuestionDataViewModel.QuestionViewModel]) {
        self.questions = data
        self.configuration = RoundConfiguration(category: data[0].category, difficulty: data[0].difficulty)
        self.currentQuestion = CurrentValueSubject<QuestionDataViewModel.QuestionViewModel, Never>(data[0])
    }
    
    var currentQuestionNumber: Int {
        return currentQuestionIndex + 1
    }
    
    var numberOfQuestions: Int {
        questions.count
    }
    
    func getPointsForCurrentQuestion() -> Int {
        // add remaining time here
        return configuration.difficulty.multiplier
    }
    
    func send(event: RoundContainerViewModel.Event) {
        self.state = self.nextState(for: event)
    }
    
    func getQuizResult() -> QuizResultViewModel {
        gcService.updateScore(to: totalPoints)
        return QuizResultViewModel(category: configuration.category,
                                   difficulty: configuration.difficulty,
                                   numberOfQuestions: questions.count,
                                   correctAnswers: correctAnswerCounter,
                                   points: totalPoints)
    }
    
    private func updateScore() {
        correctAnswerCounter += 1
        totalPoints += getPointsForCurrentQuestion()
    }
    
    private func restart() {
        self.totalPoints = 0
        self.currentQuestionIndex = 0
        self.correctAnswerCounter = 0
        self.currentQuestion.send(questions[0])
    }
    
    private func isEnd() -> Bool {
        return currentQuestionIndex == questions.count - 1
    }
}

extension RoundContainerViewModel {
    enum State {
        case idle
        case gettingReady
        case showingQuestion
        case correctAnswer
        case wrongAnswer
        case timeout
        case finished
    }
    
    enum Event {
        case onAppear
        case onFinishedAnimation
        case onAnswer(String)
        case onTimeout
        case onReplay
    }
    
    func nextState(for event: Event) -> State {
        switch state {
        case .idle: return .gettingReady
        case .gettingReady: return .showingQuestion
        case .showingQuestion:
            switch event {
            case .onAppear: return state
            case .onFinishedAnimation: return state
            case .onAnswer(let answer):
                if answer == currentQuestion.value.correctAnswer {
                    updateScore()
                    return .correctAnswer
                } else {
                    return .wrongAnswer
                }
            case .onTimeout, .onReplay: return state
            }
        case .correctAnswer: return maybeNextQuestion()
        case .wrongAnswer: return maybeNextQuestion()
        case .finished:
            switch event {
            case .onReplay:
                restart()
                return .gettingReady
            default:
                return state
            }
            
        default:
            return state
        }
    }
    
    func maybeNextQuestion() -> State {
        if isEnd() {
            playerData.accumulatedScore += totalPoints
            gcService.updateScore(to: playerData.accumulatedScore)
            return .finished
        } else {
            currentQuestionIndex += 1
            currentQuestion.send(questions[currentQuestionIndex])
            return .showingQuestion
        }
    }
}

extension UserDefaults {
    @objc var accumulatedScore: Int {
        get {
            return integer(forKey: "accumulatedScore")
        }
        set {
            set(newValue, forKey: "accumulatedScore")
        }
    }
}
