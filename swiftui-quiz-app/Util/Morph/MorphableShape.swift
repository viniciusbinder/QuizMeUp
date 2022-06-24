//
//  MorphableShape.swift
//  swiftui-quiz-app
//
//  Created by Vinícius Binder on 20/02/21.
//

import SwiftUI

struct MorphableShape: Shape {
    var controlPoints: AnimatableVector
    
    var animatableData: AnimatableVector {
        set { self.controlPoints = newValue }
        get { return self.controlPoints }
    }
    
    func point(x: Double, y: Double, rect: CGRect) -> CGPoint {
        // vector values are expected to be in the range of 0...1
        return CGPoint(x: Double(rect.width)*x, y: Double(rect.height)*y)
    }
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: self.point(x: self.controlPoints.values[0],
                                     y: self.controlPoints.values[1], rect: rect))

            var i = 2
            while i < self.controlPoints.values.count-1 {
                path.addLine(to:  self.point(x: self.controlPoints.values[i],
                                             y: self.controlPoints.values[i+1], rect: rect))
                i += 2
            }
            
            path.addLine(to:  self.point(x: self.controlPoints.values[0],
                                         y: self.controlPoints.values[1], rect: rect))
        }
    }
}
