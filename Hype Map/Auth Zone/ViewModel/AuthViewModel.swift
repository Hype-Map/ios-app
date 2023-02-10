//
//  AuthViewModel.swift
//  Hype Map
//
//  Created by Артем Соловьев on 16.01.2023.
//

import SwiftUI
import Combine
import Foundation
import CryptoKit
import AuthenticationServices
import Firebase

enum FirebaseError {
    case noUser
    case wrongPasswordLong
    case wrongEmail
    case wrongPassword
    case emailAlreadyInUse
    
    var error: String {
        switch self {
        case .noUser:
            return "There is no user record corresponding to this identifier. The user may have been deleted."
        case .wrongPasswordLong:
            return "The password must be 6 characters long or more."
        case .wrongEmail:
            return "The email address is badly formatted."
        case .wrongPassword:
            return "The password is invalid or the user does not have a password."
        case .emailAlreadyInUse:
            return "The email address is already in use by another account."
        }
    }
}

class AuthViewModel: ObservableObject {
    
    @Published var nonce = ""
    
    @Published var registerStepEmail = ""
    @Published var registerStepPassword = ""
    @Published var registerStepNickName = ""
    
    @Published var loginStepEmail = ""
    @Published var loginStepPassword = ""
    
    @Published var showAlertYPostion: CGFloat = 1000
    @Published var someError = false
    @Published var showTextError = false
    @Published var loading = false
    @Published var noUser = false
    
    @AppStorage("login_status") var login_status = false
    
    func authenicate(credential: ASAuthorizationAppleIDCredential) {
        
        //Getting token
        guard let token = credential.identityToken else {
            print("token error")
            return
        }
        
        //Convert token to string
        guard let tokenString = String(data: token, encoding: .utf8) else {
            print("error convert token to string")
            return
        }
        
        let firebaseCredential = OAuthProvider.credential(withProviderID: "apple.com", idToken: tokenString, rawNonce: nonce)
        
        Auth.auth().signIn(with: firebaseCredential) { (result, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            print("Login success")
        }
    }
    
    func emailSignUp() {
        self.showTextError = false
        withAnimation(.spring()) {
            self.loading = true
        }
        Auth.auth().createUser(withEmail: registerStepEmail, password: registerStepPassword) { result, error in
            if error == nil {
                if let result = result {
                    let refDataBase = Database.database().reference().child("Users")
                    refDataBase.child(result.user.uid).updateChildValues(["Name" : self.registerStepNickName, "Email": self.registerStepEmail])
                    
                    withAnimation(.spring()) {
                        self.login_status = true
                    }
                }
            } else if error?.localizedDescription == FirebaseError.emailAlreadyInUse.error {
                self.someError = true
                withAnimation(.spring()) {
                    self.showAlertYPostion = 0
                    self.loading = false
                    self.showTextError = true
                }
            }
        }
    }
    
    func sigInWithEmail() {
        self.showTextError = false
        withAnimation(.spring()) {
            self.loading = true
        }
        Auth.auth().signIn(withEmail: loginStepEmail, password: loginStepPassword) { result, error in
            if error?.localizedDescription == FirebaseError.noUser.error {
                self.someError = true
                self.noUser = true
                withAnimation(.spring()) {
                    self.showAlertYPostion = 0
                    self.loading = false
                    self.showTextError = true
                }
            } else if error?.localizedDescription == FirebaseError.wrongPassword.error {
                self.someError = true
                withAnimation(.spring()) {
                    self.showAlertYPostion = 0
                    self.loading = false
                    self.showTextError = true
                }
            } else if error == nil {
                withAnimation(.spring()) {
                    self.login_status = true
                    self.loading = false
                    self.showTextError = true
                }
            } else if error != nil {
                self.someError = true
                withAnimation(.spring()) {
                    self.loading = false
                }
            }
        }
    }
}
    
    //Helpers for Apple logi
    func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }
    
    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
