//
//  HypeButton.swift
//  Hype Map
//
//  Created by Артем Соловьев on 16.01.2023.
//

import SwiftUI

struct HypeButton: View {
    
    var titleButton: String = "Вход через Apple"
    var buttonColor: Color = .mainColor
    var textColor: Color = .black
    var iconButton: String = "apple.logo"
    var someFunc: () -> ()
    
    var body: some View {
        Button {
            someFunc()
        } label: {
            Rectangle()
                .cornerRadius(15)
                .frame(height: 50)
                .padding(.horizontal, 20)
                .foregroundColor(buttonColor)
                .shadow(radius: 10, x: 0, y: 4)
                .overlay {
                    HStack {
                        Image(systemName: iconButton)
                            .foregroundColor(.black)
                        Text(titleButton)
                            .foregroundColor(textColor)
                            .font(.system(size: 20))
                            .bold()
                    }
                }
        }

    }
}

struct HypeButton_Previews: PreviewProvider {
    static var previews: some View {
        HypeButton(someFunc: {print("tap")})
    }
}
