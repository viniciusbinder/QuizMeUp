//
//  DifficultyPickerView.swift
//  swiftui-quiz-app
//
//  Created by Vinícius Binder on 20/02/21.
//

import SwiftUI

struct DifficultyPickerView: View {
    @Binding var selection: Int
    let items: [String]
    
    @State private var segmentSize: CGSize = .zero
    
    private let spacing: CGFloat = 5
    
    private var selectionOffset: CGFloat {
        CGFloat(selection) * (segmentSize.width + spacing)
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(.pickerSelection)
                .shadow(radius: 2)
                .frame(width: segmentSize.width)
                .padding(.vertical, 10)
                .offset(x: selectionOffset, y: 0)
                .animation(.easeInOut(duration: 0.1))
            
            HStack(spacing: spacing) {
                ForEach(items.indices) { index in
                    Button {
                        selection = index
                    } label: {
                        Text(items[index])
                            .font(.system(size: 42))
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(PressableButtonStyle(minScale: 0.8))
                    .padding()
                    .sizeAwareness(viewSize: $segmentSize)
                }
            }
        }
        .padding(.horizontal, 10)
        .frame(maxWidth: .infinity, maxHeight: 80)
        .background(Color.pickerBackground)
        .cornerRadius(12)
    }
}

struct DifficultyPickerView_Previews: PreviewProvider {
    static var previews: some View {
        DifficultyPickerView(selection: .constant(0),
                             items: ["😌", "🧐", "🤯"])
    }
}
