//
//  CodeSentRegistrationView.swift
//  Hype Map
//
//  Created by Артем Соловьев on 15.02.2023.
//

import SwiftUI

struct CodeSentRegistrationView: View {
    
    @EnvironmentObject private var viewModel: AuthViewModel
    @State private var codeValid = false
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
                    
                    Text("Введи код с почты 💬")
                        .fontWeight(.heavy)
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                    
                    HStack(spacing: 16) {
                        HypeCircleButton(buttonColor: .white, iconColor: .mainColor, icon: "xmark") {
                            mode.wrappedValue.dismiss()
                        }
                        
                        HypeRegistrationField { value in
                            if value.count == 4 {
                                codeValid = true
                                viewModel.code = value
                            } else {
                                codeValid = false
                                viewModel.code = ""
                            }
                        }
                        .modifier(ShakeEffect(shakes: viewModel.someError ? 2 : 0))
                        
                        HypeCircleButton(buttonColor: codeValid ? .mainColor : .gray, iconColor: .white, icon: "arrowshape.forward.fill") {
                            generator.notificationOccurred(.success)
                            viewModel.verifyCode { bool in
                                goNext = bool
                            }
                        }
                        .disabled(!codeValid)
                        .animation(.spring(), value: codeValid)
                    }
                    .padding(.horizontal, 12)
                    
                    if viewModel.showTextError {
                        VStack(spacing: 15) {
                            Text("Ты ввел неправильный код 😖")
                                .font(.system(size: 17))
                                .bold()
                                .foregroundColor(.red)
                        }
                    }
                }
                .onChange(of: viewModel.someError) { newValue in
                    if viewModel.someError {
                        let generator = UINotificationFeedbackGenerator()
                        generator.notificationOccurred(.error)
                        viewModel.someError = false
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

struct CodeSentRegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        CodeSentRegistrationView().environmentObject(AuthViewModel())
    }
}
