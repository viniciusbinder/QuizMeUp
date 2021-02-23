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
    }
    
    private var content: some View {
        switch viewModel.state {
        case .idle:
            return Color.clear.erasedToAnyView
        case .gettingReady:
            return CountdownView(isAnimating: $isAnimating).transition(.identity).erasedToAnyView
        case .showingQuestion:
            return QuestionView(viewModel: viewModel.currentQuestion.value,
                                answer: $answer, code: $answerCode).erasedToAnyView
        case .correctAnswer:
            return CorrectAnswerView(isAnimating: $isAnimating, code: answerCode, text: answer ?? "").erasedToAnyView
        case .wrongAnswer:
            return WrongAnswerView(isAnimating: $isAnimating, code: answerCode, text: answer ?? "").erasedToAnyView
        default:
            return GameOverView(replay: $replayPressed, ingame: $ingame,
                                viewModel: viewModel.getQuizResult()).erasedToAnyView
        }
    }
    
    private var transition: AnyTransition {
        switch viewModel.state {
        case .correctAnswer, .wrongAnswer: return .scale
        default: return .asymmetric(insertion: .move(edge: .top), removal: .move(edge: .bottom))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RoundContainerView(viewModel: RoundContainerViewModel(data: Mocks.data.map { QuestionDataViewModel.QuestionViewModel(data: $0) }), ingame: .constant(true))
    }
}
