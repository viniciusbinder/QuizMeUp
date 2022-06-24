//
//  GameOverView.swift
//  swiftui-quiz-app
//
//  Created by Andressa Valengo on 20/02/21.
//

import SwiftUI
import ConfettiSwiftUI

struct GameOverView: View {
    
    @Binding var replay: Bool
    @Binding var ingame: Bool
    let viewModel: QuizResultViewModel
    
    @State private var confettiCounter: Int = 0

    var body: some View {
        VStack {
            Text("GAME OVER")
                .font(.poppins(weight: .semibold, size: 30))
                .foregroundColor(.white)
                .frame(height: 50)
                .frame(maxWidth: .infinity, alignment: .center)
                .background(RoundedRectangle(cornerRadius: 12).fill(Color.attentionPink))
                .padding(.horizontal)
                .padding(.bottom, 35)
            
            Text("You got")
                .font(.poppins(weight: .semibold, size: 24))
                .foregroundColor(.white)
                .padding(8)
            HStack {
                formatedNumber(for: viewModel.correctAnswers)
                
                Text("/")
                    .font(.poppins(weight: .semibold, size: 24))
                    .foregroundColor(.white)

                formatedNumber(for: viewModel.numberOfQuestions)
            }
            
            Text("You scored")
                .font(.poppins(weight: .semibold, size: 24))
                .foregroundColor(.white)
                .padding(.top, 48)
                .padding(.bottom, 8)
            HStack {
                formatedNumber(for: viewModel.points)
                
                Text("⭐️")
                    .font(.poppins(weight: .semibold, size: 30))
            }
            .confettiCannon(
                counter: $confettiCounter,
                num: 40,
                confettiSize: 20,
                rainHeight: 1200,
                radius: 450,
                repetitions: 10,
                repetitionInterval: 2.5)
            .onAppear {
                confettiCounter += 1
            }
            
            Button {
                replay = true
            } label: {
                Text("Retry")
                    .font(.poppins(weight: .bold, size: 24))
                    .foregroundColor(.black)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 4)
                    .padding(.top, 58).padding(.horizontal).padding(.horizontal)
            }
            .buttonStyle(PressableButtonStyle())
            
            Button {
                withAnimation {
                    ingame = false
                }
            } label: {
                Text("Exit")
                    .font(.poppins(weight: .bold, size: 24))
                    .foregroundColor(.black)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 4)
                    .padding(.top, 10).padding(.horizontal).padding(.horizontal)
            }
            .buttonStyle(PressableButtonStyle())

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.background.edgesIgnoringSafeArea(.all))
        .onAppear {
            replay = false
        }
    }
    
    private func formatedNumber(for n: Int) -> some View {
        Text(n > 9 ? "\(n)" : "0\(n)")
            .font(.poppins(weight: .semibold, size: 30))
            .foregroundColor(.white)
            .padding(.horizontal, 14)
            .padding(.vertical, 5)
            .background(Color.attentionPink)
            .cornerRadius(12)
    }
}

struct CornerRadiusStyle: ViewModifier {
    var radius: CGFloat
    var corners: UIRectCorner

    struct CornerRadiusShape: Shape {

        var radius = CGFloat.infinity
        var corners = UIRectCorner.allCorners

        func path(in rect: CGRect) -> Path {
            let path = UIBezierPath(roundedRect: rect,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius,
                                                        height: radius))
            return Path(path.cgPath)
        }
    }

    func body(content: Content) -> some View {
        content
            .clipShape(CornerRadiusShape(radius: radius, corners: corners))
    }
}

extension View {
    func cornerRadius(radius: CGFloat, corners: UIRectCorner) -> some View {
        ModifiedContent(content: self, modifier: CornerRadiusStyle(radius: radius, corners: corners))
    }
}

struct GameOverView_Previews: PreviewProvider {
    static var previews: some View {
        GameOverView(replay: .constant(false), ingame: .constant(true),
                     viewModel: QuizResultViewModel(category: .scienceAndNature,
                                                    difficulty: .easy,
                                                    numberOfQuestions: 10,
                                                    correctAnswers: 7,
                                                    points: 70))
    }
}
