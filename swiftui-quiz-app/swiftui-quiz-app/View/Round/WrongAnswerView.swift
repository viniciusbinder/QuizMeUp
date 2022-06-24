//
//  WrongAnswerView.swift
//  swiftui-quiz-app
//
//  Created by Andressa Valengo on 20/02/21.
//

import SwiftUI

struct WrongAnswerView: View {
    @State var scale: CGFloat = CGFloat.leastNonzeroMagnitude
    @State var emojiScale: CGFloat = CGFloat.leastNonzeroMagnitude
    
    @Binding var isAnimating: Bool
    let code: AnswerCode
    let text: String

    var body: some View {
        ZStack(alignment: .center) {
            Circle()
                .fill(Color.categoryRed)
                .scaleEffect(scale)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 50) {
                
                Text("👎")
                    .font(.poppins(weight: .bold, size: 150))
                    .scaleEffect(emojiScale)
                    .animation(.interpolatingSpring(mass: 0.01, stiffness: 0.6, damping: 0.1, initialVelocity: 5))
                
                AnswerRowView(code: code, text: text)
            }
        }
        .onAppear {
            isAnimating = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                isAnimating = false
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(Animation.easeIn(duration: 2)) {
                    scale = 5
                    emojiScale = 1
                }
            }
        }
    }
}
