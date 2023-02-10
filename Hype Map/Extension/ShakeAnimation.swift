//
//  ShakeAnimation.swift
//  Hype Map
//
//  Created by Артем Соловьев on 18.01.2023.
//

import SwiftUI

struct ShakeEffect: GeometryEffect {
    
    private let generator = UINotificationFeedbackGenerator()
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        return ProjectionTransform(CGAffineTransform(translationX: -30 * sin(position * 2 * .pi), y: 0))
    }
    
    init(shakes: Int) {
        position = CGFloat(shakes)
    }
    
    var position: CGFloat
    var animatableData: CGFloat {
        get { position }
        set { position = newValue }
    }
}
