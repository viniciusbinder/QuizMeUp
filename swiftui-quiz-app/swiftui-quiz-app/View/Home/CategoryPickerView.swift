//
//  CategoryPickerView.swift
//  swiftui-quiz-app
//
//  Created by Vinícius Binder on 20/02/21.
//

import SwiftUI

struct CategoryPickerView: View {
    @Binding var category: Int
    @Binding var shouldExpand: Bool
    
    @ObservedObject private var viewModel = CategoryViewModel()
    
    @State private var selection: Int = 0 {
        didSet {
            category = viewModel.categories[selection].id
        }
    }
    @State private var selectionControlPoints: AnimatableVector =
        Circle().path(in: CGRect(x: 0, y: 0, width: 1, height: 1)).controlPoints()
    
    @State private var expandScale: CGFloat = 1
    @State private var expandOpacity: Double = 1
    
    typealias CategoryConfig = (color: Color, emoji: String)
    
    private let categoryConfigs = [
        CategoryConfig(.categoryDarkBlue, CategoryType.random.emoji),
        CategoryConfig(.categoryYellow, CategoryType.art.emoji),
        CategoryConfig(.categoryPurple, CategoryType.generalKnowledge.emoji),
        CategoryConfig(.categoryRed, CategoryType.geography.emoji),
        CategoryConfig(.categoryLightBlue, CategoryType.history.emoji),
        CategoryConfig(.categoryOrange, CategoryType.mythology.emoji),
        CategoryConfig(.categoryGreen, CategoryType.scienceAndNature.emoji)
    ]
    private func categoryColor(for index: Int) -> Color {
        guard viewModel.categories.indices.contains(index) else { return .clear }
        return categoryConfigs[index].color
    }

    private func categoryView(for index: Int) -> some View {
        var config = CategoryConfig(.clear, "     ")
        if index >= viewModel.categories.count {
            config = CategoryConfig(.clear, "     ")
        } else if index >= 0 {
            config = categoryConfigs[index]
        }
        return Text(config.emoji)
            .font(.poppins(weight: .semibold, size: 18))
            .background(Circle()
                            .fill(config.color)
                            .shadow(radius: 2)
                            .frame(width: 50, height: 50))
            .id("categoryView-\(index)")
            .transition(.asymmetric(insertion: .scale, removal: .opacity))
            .animation(.easeIn)
            .erasedToAnyView
    }
    
    private func swap(change: Int) {
        guard viewModel.categories.indices.contains(selection+change) else { return }
        
        withAnimation {
            selection += change
            
            if selection.isMultiple(of: 2) {
                selectionControlPoints = Circle().path(in: CGRect(x: 0, y: 0, width: 1, height: 1)).controlPoints()
            } else {
                selectionControlPoints = Rectangle().rotation(.degrees(45)).path(in: CGRect(x: 0, y: 0, width: 1, height: 1)).controlPoints()
    //            selectionControlPoints = Star(corners: 10, smoothness: 0.8).path(in: CGRect(x: 0, y: 0, width: 1, height: 1)).controlPoints()
            }
        }
    }
    
    private func expand() {
        withAnimation(.easeIn(duration: 0.2)) {
            expandScale = 0
            expandOpacity = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(Animation.interpolatingSpring(mass: 0.01, stiffness: 0.6, damping: 0.1, initialVelocity: 5)) {
                expandScale = 6
                GameCenter.shared.showAccessPoint(show: false)
            }
        }
    }
    
    private func CategoryView(category: CategoryViewModel.Category) -> some View {
        VStack {
            Text(category.emoji)
                .font(.system(size: 48))

            Text(category.description)
                .font(.poppins(weight: .semibold, size: 24))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 150)
        }
        .offset(y: -10)
        .transition(AnyTransition.scale.combined(with: .opacity))
        .zIndex(10)
        .opacity(expandOpacity)
    }
    
    var body: some View {
        HStack(spacing: 20) {
            Button {
                swap(change: -1)
            } label: {
                categoryView(for: selection - 1)
            }
            .buttonStyle(PressableButtonStyle(minScale: 0.8, duration: 0.1))
            
            ZStack(alignment: .center) {
                let category = viewModel.categories[selection]
                
                MorphableShape(controlPoints: selectionControlPoints)
                    .fill(categoryColor(for: selection))
                    .shadow(radius: 8)
                    .frame(width: 190, height: 190)
                    .scaleEffect(selection.isMultiple(of: 2) ? 1 : 0.8)
                    .animation(.interpolatingSpring(mass: 0.01, stiffness: 0.6, damping: selection.isMultiple(of: 2) ? 0.1 : 0.08, initialVelocity: 10))
                
                if selection.isMultiple(of: 2) {
                    CategoryView(category: category)
                } else {
                    CategoryView(category: category)
                }
            }
            .scaleEffect(expandScale)
            .zIndex(1)
            
            Button {
                swap(change: 1)
            } label: {
                categoryView(for: selection + 1)
            }
            .buttonStyle(PressableButtonStyle(minScale: 0.8, duration: 0.1))
        }
        .background(Color.background)
        .gesture(DragGesture(minimumDistance: 3.0, coordinateSpace: .local)
                    .onEnded { value in
                        guard -50...50 ~= value.translation.height else { return }
                        
                        if value.translation.width < 0 {
                            swap(change: 1)
                        } else if value.translation.width > 0 {
                            swap(change: -1)
                        }
                    })
        .onChange(of: shouldExpand) { newValue in
            if newValue {
                expand()
            }
        }
    }
}

struct CategoryPickerView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryPickerView(category: .constant(0), shouldExpand: .constant(false))
    }
}
