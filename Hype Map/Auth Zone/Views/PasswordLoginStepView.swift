//
//  PasswordLoginStepView.swift
//  Hype Map
//
//  Created by Артем Соловьев on 17.01.2023.
//

import SwiftUI

struct PasswordLoginStepView: View {
    
    @EnvironmentObject private var viewModel: AuthViewModel
    @State private var passwordlValid = false
    @Environment(\.presentationMode) private var mode: Binding<PresentationMode>
    
    private let minDragTranslationForSwipe: CGFloat = 20
    private let generator = UINotificationFeedbackGenerator()
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: .init(colors: [Color.mainColor, Color.blueColor]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 25) {
                    Text("Введите пароль 🫣")
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
                                viewModel.loginStepPassword = value
                            } else {
                                passwordlValid = false
                                viewModel.loginStepPassword = ""
                            }
                        }
                        .modifier(ShakeEffect(shakes: viewModel.someError ? 2 : 0))
                        
                        HypeCircleButton(buttonColor: passwordlValid ? .mainColor : .gray, iconColor: .white, icon: "arrowshape.forward.fill") {
                            generator.notificationOccurred(.success)
                            viewModel.sigInWithEmail()
                        }
                        .disabled(!passwordlValid)
                        .animation(.spring(), value: passwordlValid)
                    }
                    .padding(.horizontal, 12)
                    
                    if viewModel.showTextError {
                        HStack {
                            Text(viewModel.noUser ? "Такого пользователя нет у нас 😣" : "Email или пароль не верны! 😟")
                                .font(.system(size: 17))
                                .bold()
                                .foregroundColor(.red)
                        }
                    }
                }
                .opacity(viewModel.loading ? 0 : 1)
                .onChange(of: viewModel.someError) { newValue in
                    if viewModel.someError {
                        let generator = UINotificationFeedbackGenerator()
                        generator.notificationOccurred(.error)
                        viewModel.someError = false
                    }
                }
                
                if viewModel.loading {
                    VStack {
                        ProgressView()
                            .tint(.white)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .highPriorityGesture(DragGesture().onEnded({
            self.handleSwipe(translation: $0.translation.width)
        }))
        .onAppear() {
            viewModel.showTextError = false
        }
    }
    
    private func handleSwipe(translation: CGFloat) {
        if translation > minDragTranslationForSwipe {
            mode.wrappedValue.dismiss()
        }
    }
}

struct PasswordLoginStepView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordLoginStepView().environmentObject(AuthViewModel())
    }
}
