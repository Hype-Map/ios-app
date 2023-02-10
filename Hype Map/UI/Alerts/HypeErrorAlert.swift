//
//  HypeErrorAlert.swift
//  Hype Map
//
//  Created by Артем Соловьев on 18.01.2023.
//

import SwiftUI

struct HypeErrorAlert: View {
    
    var textOfAlert: String = "test"
    var textColor: Color = .white
    var buttonColor: Color = .white
    var backgroundAlertColor: Color = .mainColor
    var viewModel: AuthViewModel
    var funcOfAlert: () -> ()
    
    private let generator = UINotificationFeedbackGenerator()
    @Environment(\.presentationMode) private var mode: Binding<PresentationMode>
    
    var body: some View {
        VStack(spacing: 25) {
            Text(textOfAlert)
                .foregroundColor(textColor)
                .font(.system(size: 15))
                .bold()
                .padding(.horizontal, 20)
            
            HypeButton(titleButton: "Хорошо", buttonColor: buttonColor , textColor: .white, iconButton: "") {
                funcOfAlert()
                generator.notificationOccurred(.success)
            }
        }
        .frame(width: .infinity, height: 200)
        .background(backgroundAlertColor.edgesIgnoringSafeArea(.all))
        .cornerRadius(20)
        .padding(.horizontal, 20)
//        .shadow(radius: 10, x: -10, y: 15)
        .onChange(of: viewModel.showAlertYPostion) { newValue in
            if viewModel.showAlertYPostion == 0 {
                generator.notificationOccurred(.error)
            }
        }
    }
}
