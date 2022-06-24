//
//  CountdownView.swift
//  swiftui-quiz-app
//
//  Created by Andressa Valengo on 20/02/21.
//

import SwiftUI

struct CountdownView: View {
    
    @Binding var isAnimating: Bool
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var timeRemaining = 3.0
    
    
    var body: some View {
        VStack {
            Text("GET READY!")
                .font(.poppins(weight: .semibold, size: 28))
                .foregroundColor(.white)
                .padding(.vertical, 5)
            
            Text(String(format: "%.0f", timeRemaining))
                .font(.poppins(weight: .bold, size: 100))
                .foregroundColor(.white)
                .padding(.vertical, 5)
                .id("TimerText-\(timeRemaining)")
                .transition(.asymmetric(insertion: .scale, removal: .opacity))
                .animation(.easeIn)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background.edgesIgnoringSafeArea(.all))
        .onAppear {
            isAnimating = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                isAnimating = false
            }
        }
        .onReceive(timer) { time in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            }
        }
    }
}

struct CountdownView_Previews: PreviewProvider {
    static var previews: some View {
        CountdownView(isAnimating: .constant(true))
    }
}
