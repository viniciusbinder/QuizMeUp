//
//  Font.swift
//  swiftui-quiz-app
//
//  Created by Vinícius Binder on 20/02/21.
//

import SwiftUI

struct Poppins {
    enum Weight: String {
        case bold = "Bold"
        case semibold = "SemiBold"
    }
}

extension Font {
    static func poppins(weight: Poppins.Weight, size: CGFloat) -> Font {
        Font.custom("Poppins-" + weight.rawValue, size: size)
    }
}
