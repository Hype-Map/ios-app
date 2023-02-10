//
//  PasswordStepRegestrationView.swift
//  Hype Map
//
//  Created by Артем Соловьев on 17.01.2023.
//

import SwiftUI

struct PasswordStepRegestrationView: View {
    
    @EnvironmentObject private var viewModel: AuthViewModel
    @State private var passwordlValid = false
    @State private var goNext: Bool? = false
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    private let minDragTranslationForSwipe: CGFloat = 20
    private let generator = UINotificationFeedbackGenerator()
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: .init(colors: [Color.mainColor, Color.blueColor]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
                
                NavigationLink(tag: true, selection: $goNext) {
                   NickStepRegistrationView()
                } label: {
                    EmptyView()
                }
                
                VStack(spacing: 25) {
                    Text("Придумайте пароль 🫣")
                        .fontWeight(.heavy)
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                    
                    HStack(spacing: 16) {
                        HypeCircleButton(buttonColor: .white, iconColor: .mainColor, icon: "arrowshape.backward.fill") {
                            mode.wrappedValue.dismiss()
                        }
                        
                        HypeRegistrationFieldSecure { value in
                            if value.count >= 8 {
                                passwordlValid = true
                                viewModel.registerStepPassword = value
                            } else {
                                passwordlValid = false
                                viewModel.registerStepPassword = ""
                            }
                        }
                        
                        HypeCircleButton(buttonColor: passwordlValid ? .mainColor : .gray, iconColor: .white, icon: "arrowshape.forward.fill") {
                            generator.notificationOccurred(.success)
                            goNext = true
                        }
                        .disabled(!passwordlValid)
                        .animation(.spring(), value: passwordlValid)
                    }
                    .padding(.horizontal, 12)
                }
            }
        }
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

struct PasswordStepRegestrationView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordStepRegestrationView().environmentObject(AuthViewModel())
    }
}
