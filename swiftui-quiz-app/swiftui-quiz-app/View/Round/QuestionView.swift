//
//  QuestionUIView.swift
//  swiftui-quiz-app
//
//  Created by Andressa Valengo on 20/02/21.
//

import SwiftUI

struct QuestionView: View {
    
    let viewModel: QuestionDataViewModel.QuestionViewModel
    
    @Binding var answer: String?
    @Binding var code: AnswerCode
    
    var body: some View {
        VStack(spacing: 40) {
            // Timer
            
            Text(viewModel.question)
                .font(.poppins(weight: .semibold, size: 30))
                .minimumScaleFactor(0.01)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal).padding(.horizontal)
            
            Spacer()
            
            VStack(spacing: 19) {
                ForEach(0..<viewModel.answers.count) { index in
                    Button {
                        self.answer = viewModel.answers[index]
                        self.code = AnswerCode.getCode(for: index)
                    } label: {
                        AnswerRowView(code: AnswerCode.getCode(for: index), text: viewModel.answers[index])
                    }
                    .buttonStyle(PressableButtonStyle())
                }
            }
            .padding(.bottom, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background.edgesIgnoringSafeArea(.all))
        .animation(.spring())
    }
}

struct QuestionUIView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionView(viewModel: QuestionDataViewModel.QuestionViewModel(data: Mocks.data[0]),
                     answer: .constant(nil), code: .constant(.A))
    }
}
