//
//  HypeRegistrationField.swift
//  Hype Map
//
//  Created by Артем Соловьев on 17.01.2023.
//

import SwiftUI

struct HypeRegistrationField: View {
    
    @State var textFieldText = ""
    var someFunc: (String) -> ()
    
    var body: some View {
        HStack {
            TextField("", text: $textFieldText)
                .onChange(of: textFieldText, perform: { oldValue in
                    someFunc(oldValue)
                })
                .padding(.horizontal, 15)
                .frame(height: 50)
                .foregroundColor(.black)
        }
        .background(Color.white)
        .frame(width: 235, height: 50)
        .cornerRadius(15)
        .shadow(radius: 10, x: 0, y: 4)
    }
}

struct HypeRegistrationFieldSecure: View {
    
    @State var textFieldText = ""
    @State private var isSecured: Bool = true
    var someFunc: (String) -> ()
    
    var body: some View {
        ZStack(alignment: .trailing) {
            Group {
                if isSecured {
                    SecureField("", text: $textFieldText)
                        .onChange(of: textFieldText, perform: { oldValue in
                            someFunc(oldValue)
                        })
                        .padding(.horizontal, 15)
                        .frame(height: 50)
                        .foregroundColor(.black)
                } else {
                    TextField("", text: $textFieldText)
                        .onChange(of: textFieldText, perform: { oldValue in
                            someFunc(oldValue)
                        })
                        .padding(.horizontal, 15)
                        .frame(height: 50)
                        .foregroundColor(.black)
                }
            }.padding(.trailing, 32)

            Button(action: {
                withAnimation(.spring()) {
                    isSecured.toggle()
                }
            }) {
                Text(self.isSecured ? "🙈 " : "🙉 ")
                    .padding(.trailing, 15)
            }
        }
        .background(Color.white)
        .frame(width: 235, height: 50)
        .cornerRadius(15)
        .shadow(radius: 10, x: 0, y: 4)
    }
}

