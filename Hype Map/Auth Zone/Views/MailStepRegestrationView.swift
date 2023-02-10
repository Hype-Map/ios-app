//
//  MailStepRegestrationView.swift
//  Hype Map
//
//  Created by Артем Соловьев on 17.01.2023.
//

import SwiftUI

struct MailStepRegestrationView: View {
    
    @StateObject private var viewModel = AuthViewModel()
    @State private var emailValid = false
    @State private var goNext: Bool? = false
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    private let minDragTranslationForSwipe: CGFloat = 20
    private let generator = UINotificationFeedbackGenerator()
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: .init(colors: [Color.mainColor, Color.blueColor]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 25) {
                    NavigationLink(tag: true, selection: $goNext) {
                       PasswordStepRegestrationView()
                    } label: {
                        EmptyView()
                    }
                    
                    Text("Введите ваш Email 📬")
                        .fontWeight(.heavy)
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                    
                    HStack(spacing: 16) {
                        HypeCircleButton(buttonColor: .white, iconColor: .mainColor, icon: "xmark") {
                            mode.wrappedValue.dismiss()
                        }
                        
                        HypeRegistrationField { value in
                            if value.contains("@") {
                                emailValid = true
                                viewModel.registerStepEmail = value
                            } else {
                                emailValid = false
                                viewModel.registerStepEmail = ""
                            }
                        }
                        
                        HypeCircleButton(buttonColor: emailValid ? .mainColor : .gray, iconColor: .white, icon: "arrowshape.forward.fill") {
                            generator.notificationOccurred(.success)
                            goNext = true
                        }
                        .disabled(!emailValid)
                        .animation(.spring(), value: emailValid)
                    }
                    .padding(.horizontal, 12)
                }
            }
        }
        .environmentObject(viewModel)
        .navigationBarBackButtonHidden(true)
        .highPriorityGesture(DragGesture().onEnded({
            self.handleSwipe(translation: $0.translation.width)
        }))
    }
    
    private func handleSwipe(translation: CGFloat) {
        if translation > minDragTranslationForSwipe {
            mode.wrappedValue.dismiss()
        }
    }
}

struct MailStepRegestrationView_Previews: PreviewProvider {
    static var previews: some View {
        MailStepRegestrationView()
    }
}
