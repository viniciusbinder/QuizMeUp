//
//  CateogoryViewModel.swift
//  swiftui-quiz-app
//
//  Created by Andressa Valengo on 20/02/21.
//

import Foundation
import Combine


class CategoryViewModel: ObservableObject {
    class Category: Identifiable {
        let id: Int
        let description: String
        let emoji: String
        
        init(forType type: CategoryType) {
            self.id = type.id
            self.description = type.rawValue
            self.emoji = type.emoji
        }
    }
    
    @Published var categories: [Category] = CategoryType.allCases.map { Category(forType: $0) }
}

