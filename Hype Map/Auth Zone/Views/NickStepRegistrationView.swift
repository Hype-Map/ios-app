//
//  NickStepRegistrationView.swift
//  Hype Map
//
//  Created by Артем Соловьев on 17.01.2023.
//

import SwiftUI

struct NickStepRegistrationView: View {
    
    @EnvironmentObject private var viewModel: AuthViewModel
    @State private var nicklValid = false
    @Environment(\.presentationMode) private var mode: Binding<PresentationMode>
    
    private let minDragTranslationForSwipe: CGFloat = 20
    private let generator = UINotificationFeedbackGenerator()
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: .init(colors: [Color.mainColor, Color.blackMain]), startPoint: .top, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 25) {
                Text("Придумайте ваш ник! 🥳")
                    .fontWeight(.heavy)
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                
                HStack(spacing: 16) {
                    HypeCircleButton(buttonColor: .white, iconColor: .mainColor, icon: "arrowshape.backward.fill") {
                        mode.wrappedValue.dismiss()
                    }
                    
                    HypeRegistrationField { value in
                        if value.count >= 4 {
                            nicklValid = true
                            viewModel.registerStepNickName = value
                        } else {
                            nicklValid = false
                            viewModel.registerStepNickName = ""
                        }
                    }
                    .modifier(ShakeEffect(shakes: viewModel.someError ? 2 : 0))
                    
                    HypeCircleButton(buttonColor: nicklValid ? .mainColor : .gray, iconColor: .white, icon: "arrowshape.forward.fill") {
                        generator.notificationOccurred(.success)
                        viewModel.signUp()
                    }
                    .disabled(!nicklValid)
                    .animation(.spring(), value: nicklValid)
                }
                .padding(.horizontal, 12)
                
                if viewModel.nickAlreadyExists {
                    HStack {
                        Text("Такой ник уже занят... 😢")
                            .font(.system(size: 17))
                            .bold()
                            .foregroundColor(.red)
                    }
                } else if viewModel.showTextError {
                    HStack {
                        Text("Этот пользователь уже есть у нас 🤔")
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

struct NickStepRegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        NickStepRegistrationView().environmentObject(AuthViewModel())
    }
}
