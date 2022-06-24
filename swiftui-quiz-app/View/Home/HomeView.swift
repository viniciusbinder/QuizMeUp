//
//  HomeView.swift
//  swiftui-quiz-app
//
//  Created by Andressa Valengo on 20/02/21.
//

import SwiftUI
import GameKit

struct HomeView: View {
    @ObservedObject var viewModel: QuestionDataViewModel
    @Binding var ingame: Bool
    
    @State private var difficulty = 0
    @State private var categoryID = CategoryType.random.id
    
    var body: some View {
        VStack {
            Image("banner")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.top, 80)
                .padding(.horizontal).padding(.horizontal)
            
            Spacer()
            CategoryPickerView(category: $categoryID, shouldExpand: .constant(viewModel.state == .loaded))
                .zIndex(1)
            Spacer()
            
            DifficultyPickerView(selection: $difficulty, items: ["😌", "🧐", "🤯"])
                .padding().padding(.horizontal)
            
            Button {
                if viewModel.state != .loading {
                    withAnimation {
                        viewModel.load(for: categoryID, with: Difficulty.from(int: difficulty))
                    }
                }
            } label: {
                Text("Play")
                    .font(.poppins(weight: .bold, size: 24))
                    .foregroundColor(viewModel.state == .loading ? .clear : .black)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 4)
                    .padding().padding(.horizontal)
                    .overlay(viewModel.state == .loading
                             ? AnyView(ProgressView().progressViewStyle(CircularProgressViewStyle()))
                             : AnyView(EmptyView()))
            }
            .buttonStyle(PressableButtonStyle())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            GameCenter.shared.authenticateUser()
            withAnimation {
                GameCenter.shared.showAccessPoint(show: true)
            }
        }
        .onChange(of: viewModel.state) { newValue in
            if newValue == .loaded {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation {
                        ingame = true
                    }
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: QuestionDataViewModel(), ingame: .constant(false))
    }
}
