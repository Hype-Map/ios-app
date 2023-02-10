//
//  HypeGlassButton.swift
//  Hype Map
//
//  Created by Артем Соловьев on 25.01.2023.
//

import SwiftUI

struct HypeGlassButton: View {
    
    var imageButton: String?
    var width: CGFloat?
    var height: CGFloat?
    var someFunc: () -> ()
    
    var body: some View {
        Button(action: {
            someFunc()
        }, label: {
            RoundedRectangle(cornerRadius: 12)
                .fill(.white).opacity(0.15)
                .blur(radius: 1)
                .overlay(content: {
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(LinearGradient(gradient: .init(colors: [Color.white, Color.white.opacity(0.3)]), startPoint: .top, endPoint: .bottom), lineWidth: 2).opacity(0.2)
                    Image(imageButton ?? "")
                })
        })
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
        .frame(width: width, height: height)
    }
}
