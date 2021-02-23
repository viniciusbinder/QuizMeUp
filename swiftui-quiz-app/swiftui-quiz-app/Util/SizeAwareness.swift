//
//  SizeAwareness.swift
//  swiftui-quiz-app
//
//  Created by Vinícius Binder on 20/02/21.
//

import SwiftUI

// PreferenceKey for a subview to notify superview of its size
struct SizePreferenceKey: PreferenceKey {
    typealias Value = CGSize // Define that the PreferenceKey attribute is of type CGSize
    static var defaultValue: CGSize = .zero // Default to zero size
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

// View that will serve as the background of one of our text elements (the subview)
struct BackgroundGeometryReader: View {
    var body: some View {
        // Wrapping background in GeometryReader so we can read the size ("Trick")
        GeometryReader { geometry in
            return Color
                    .clear
                    // Passing the size to key
                    .preference(key: SizePreferenceKey.self, value: geometry.size)
        }
    }
}

// Helper ViewModifier to attach to the subview that encapsulates the PreferenceKey
struct SizeAwareViewModifier: ViewModifier {
    @Binding var viewSize: CGSize

    func body(content: Content) -> some View {
        content
            // Get size of view
            .background(BackgroundGeometryReader())
            // Watch for changes then update binding
            .onPreferenceChange(SizePreferenceKey.self, perform:
                                    { if self.viewSize != $0 { self.viewSize = $0 }})
    }
}

extension View {
    func sizeAwareness(viewSize: Binding<CGSize>) -> some View {
        self.modifier(SizeAwareViewModifier(viewSize: viewSize))
    }
}
