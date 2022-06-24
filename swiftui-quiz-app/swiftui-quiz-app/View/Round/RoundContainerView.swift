//
//  RoundView.swift
//  QuizApp
//
//  Created by Andressa Valengo on 20/02/21.
//

import SwiftUI

struct RoundContainerView: View {
    
    @ObservedObject var viewModel: RoundContainerViewModel
    @Binding var ingame: Bool
    
    @State var isAnimating = false
    @State var hasTimedout = false
    @State var replayPressed = false
    @State var answer: String? = nil
    @State var answerCode: AnswerCode = .A
    
    @State private var confettiCounter: Int = 0
    
    var body: some View {
        VStack {
            Group {
                if viewModel.state == .showingQuestion {
                    HeaderView(category: viewModel.currentQuestion.value.category, question: (n: viewModel.currentQuestionNumber, max: viewModel.numberOfQuestions), points: viewModel.totalPoints)
                } else if viewModel.state == .finished {
                    HeaderView(category: viewModel.currentQuestion.value.category)
                }
            }
            .transition(.move(edge: .top))
            .animation(.easeInOut(duration: 0.5))
            .zIndex(0)
            .padding(.bottom, 25)
            
            self.content
                .id(viewModel.state)
                .transition(transition)
                .animation(.easeInOut(duration: 0.5))
                .zIndex([.correctAnswer, .wrongAnswer].contains(viewModel.state) ? 1 : -1)
        }
        .edgesIgnoringSafeArea(.top)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            withAnimation {
                viewModel.send(event: .onAppear)
            }
        }
        .onChange(of: isAnimating, perform: { _ in
            if !isAnimating {
                withAnimation {
                    viewModel.send(event: .onFinishedAnimation)
                }
            }
        })
        .onChange(of: answer, perform: { value in
            if let answer = value {
                withAnimation {
                    viewModel.send(event: .onAnswer(answer))
                }
            }
        })
        .onChange(of: replayPressed, perform: { replay in
            if replay {
                withAnimation {
                    viewModel.send(event: .onReplay)
                }
            }
        })
        .confettiCannon(
            counter: $confettiCounter,
            num: 30,
            confettiSize: 20,
            rainHeight: 1200,
            radius: 450,
            repetitions: 10,
            repetitionInterval: 2.5)
    }
    
    private var content: some View {
        Group {
            switch viewModel.state {
            case .idle:
                Color.clear
            case .gettingReady:
                CountdownView(isAnimating: $isAnimating).transition(.identity)
            case .showingQuestion:
                QuestionView(viewModel: viewModel.currentQuestion.value,
                             answer: $answer, code: $answerCode)
            case .correctAnswer:
                CorrectAnswerView(isAnimating: $isAnimating, code: answerCode, text: answer ?? "")
            case .wrongAnswer:
                WrongAnswerView(isAnimating: $isAnimating, code: answerCode, text: answer ?? "")
            default:
                GameOverView(replay: $replayPressed, ingame: $ingame,
                             viewModel: viewModel.getQuizResult())
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        confettiCounter += 1
                    }
                }
            }
        }
    }
    
    private var transition: AnyTransition {
        switch viewModel.state {
        case .correctAnswer, .wrongAnswer: return .scale
        default: return .asymmetric(insertion: .move(edge: .top), removal: AnyTransition.opacity.animation(.easeIn(duration: 0.45)).combined(with: .move(edge: .bottom)))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RoundContainerView(viewModel: RoundContainerViewModel(data: Mocks.data.map { QuestionDataViewModel.QuestionViewModel(data: $0) }), ingame: .constant(true))
    }
}
