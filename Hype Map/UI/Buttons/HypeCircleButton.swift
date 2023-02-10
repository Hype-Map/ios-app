//
//  HypeCircleButton.swift
//  Hype Map
//
//  Created by Артем Соловьев on 17.01.2023.
//

import SwiftUI

struct HypeCircleButton: View {
    
    var buttonColor: Color = .mainColor
    var iconColor: Color = .white
    var icon: String = "arrowshape.forward.fill"
    var someFunc: () -> ()
    
    var body: some View {
        Button {
            someFunc()
        } label: {
            Circle()
                .frame(width: 50, height: 50)
                .foregroundColor(buttonColor)
                .overlay {
                    Image(systemName: icon)
                        .foregroundColor(iconColor)
                }
        }
        .shadow(radius: 10, x: 0, y: 4)
    }
}

struct HypeCircleButton_Previews: PreviewProvider {
    static var previews: some View {
        HypeCircleButton {
            print("test")
        }
    }
}
