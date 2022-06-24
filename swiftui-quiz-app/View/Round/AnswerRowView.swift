//
//  AnswerRowView.swift
//  swiftui-quiz-app
//
//  Created by Andressa Valengo on 21/02/21.
//

import SwiftUI


struct AnswerRowView: View {
    
    let code: AnswerCode
    let text: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.white)
                .shadow(radius: 4, y: 4)
            
            HStack(spacing: 16) {
                Circle().fill(fillColor)
                    .overlay(
                        Text(code.rawValue)
                            .font(.poppins(weight: .bold, size: 24))
                            .foregroundColor(.white)
                    )
                    .frame(width: 44)
                    .padding(.vertical, 11)
                
                Text(text)
                    .font(.poppins(weight: .bold, size: 20))
                    .minimumScaleFactor(0.01)
            }
            .padding(.horizontal, 11)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(height: 66)
        .padding(.horizontal).padding(.horizontal)
    }
    
    private var fillColor: Color {
        switch code {
        case .A: return Color.optionA
        case .B: return Color.optionB
        case .C: return Color.optionC
        case .D: return Color.optionD
        }
    }
    
}

struct AnswerRowView_Previews: PreviewProvider {
    static var previews: some View {
        AnswerRowView(code: .A, text: "Zeus")
    }
}
