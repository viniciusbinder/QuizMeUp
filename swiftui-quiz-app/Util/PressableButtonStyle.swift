//
//  PressableButtonStyle.swift
//  swiftui-quiz-app
//
//  Created by Vinícius Binder on 20/02/21.
//

import SwiftUI

struct PressableButtonStyle: ButtonStyle {
    private let minScale: CGFloat
    private let duration: Double
    
    init(minScale: CGFloat = 0.95, duration: Double = 0.05) {
        self.minScale = minScale
        self.duration = duration
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? minScale : 1.0)
            .animation(.easeIn(duration: duration), value: configuration.isPressed)
    }
}
