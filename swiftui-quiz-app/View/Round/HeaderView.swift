//
//  HeaderView.swift
//  swiftui-quiz-app
//
//  Created by Vinícius Binder on 21/02/21.
//

import SwiftUI

struct HeaderView: View {
    private let category: CategoryType
    private let question: (n: Int, max: Int)?
    private let points: Int?
    
    init(category: CategoryType, question: (n: Int, max: Int)? = nil, points: Int? = nil) {
        self.category = category
        self.question = question
        self.points = points
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Rectangle()
                .fill(Color.header)
                .frame(height: 106).frame(maxWidth: .infinity)
                .cornerRadius(radius: 12, corners: [.bottomRight, .bottomLeft])
                .shadow(radius: 1)
            
            HStack(alignment: .bottom) {
                if let question = question {
                    Text("\(question.n)/\(question.max)")
                        .font(.poppins(weight: .semibold, size: 18))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                VStack {
                    Text("\(category.emoji)")
                        .font(.poppins(weight: .semibold, size: 20))
                    
                    Text(category.rawValue)
                        .font(.poppins(weight: .semibold, size: 18))
                        .foregroundColor(.white)
                        .textCase(.uppercase)
                        .lineLimit(1)
                        .layoutPriority(1)
                }
                
                Spacer()
                
                if let points = points {
                    Text("\(points) ⭐️")
                        .font(.poppins(weight: .semibold, size: 18))
                        .foregroundColor(.white)
                }
            }
            .padding(.bottom, 7)
            .padding(.horizontal, 15)
        }
        .padding(.horizontal)
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(category: .geography)
    }
}
