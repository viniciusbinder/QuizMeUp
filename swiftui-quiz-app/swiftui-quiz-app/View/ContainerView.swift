//
//  ContainerView.swift
//  swiftui-quiz-app
//
//  Created by Vinícius Binder on 21/02/21.
//

import SwiftUI
import ConfettiSwiftUI

struct ContainerView: View {
    @ObservedObject private var viewModel = QuestionDataViewModel()
    @State private var ingame = false
    
    var body: some View {
        ZStack {
            if ingame {
                RoundContainerView(viewModel: RoundContainerViewModel(data: viewModel.data), ingame: $ingame)
                    .transition(.identity)
            } else {
                HomeView(viewModel: viewModel, ingame: $ingame)
                    .zIndex(1)
                    .transition(.scale)
            }
        }
        .background(Color.background.edgesIgnoringSafeArea(.all))
    }
}

struct ContainerView_Previews: PreviewProvider {
    static var previews: some View {
        ContainerView()
    }
}
