//
//  MainAuthScreen.swift
//  Hype Map
//
//  Created by Артем Соловьев on 16.01.2023.
//

import SwiftUI
import AuthenticationServices

struct MainAuthScreen: View {
    
    @StateObject private var viewModel = AuthViewModel()
    @State private var goNext: Bool? = false
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: .init(colors: [Color.mainColor, Color.blueColor]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
                
                NavigationLink(tag: true, selection: $goNext) {
                   MailStepRegestrationView()
                } label: {
                    EmptyView()
                }
                
                VStack {
                    Image("Logo2")
                        .resizable()
                        .cornerRadius(14)
                        .frame(width: 130, height: 130)
                        .padding(.top, 60)
                    
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        Text("HYPE MAP -")
                            .font(.system(size: 32))
                            .fontWeight(.heavy)
                        
                        Text("приложение по обмену геолокацией с вашими друзьями!")
                            .font(.system(size: 20))
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    VStack(spacing: 15) {
                        SignInWithAppleButton { (request) in
                        } onCompletion: { (result) in
                            switch result {
                            case .success(let user):
                                print("success")
                                
                                //Going Firebase login
                                guard let credential = user.credential as? ASAuthorizationAppleIDCredential else {
                                    print("credential firebase error")
                                    return
                                }
                                
                            case .failure(let error):
                                print(error.localizedDescription)
                            }
                        }
                        .signInWithAppleButtonStyle(.white)
                        .frame(height: 50)
                        .cornerRadius(15)
                        .shadow(radius: 10, x: 0, y: 4)
                        .padding(.horizontal, 20)
                        
                        HypeButton(titleButton: "Регистрация с Email", buttonColor: .mainColor, textColor: .white, iconButton: "") {
                           goNext = true
                        }
                        
                        NavigationLink {
                            MailLoginStepView()
                        } label: {
                            Text("Войти")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                                .bold()
                        }
                    }
                    
                    Spacer()
                }
            }
        }
    }
}

struct MainAuthScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainAuthScreen()
    }
}
