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

class AuthViewModel: ObservableObject {
    static let shared = AuthViewModel()
    
    @Published var nonce = ""
    
    @Published var registerStepEmail = ""
    @Published var registerStepPassword = ""
    @Published var registerStepNickName = ""
    @Published var code = ""
    
    @Published var loginStepEmail = ""
    @Published var loginStepPassword = ""
    
    @Published var showAlertYPostion: CGFloat = 1000
    @Published var someError = false
    @Published var showTextError = false
    @Published var nickAlreadyExists = false
    @Published var loading = false
    @Published var noUser = false
    
    @AppStorage("login_status") var login_status = false
    
    private let apiShared = ApiManager.shared
    
    func sendCode(comletition: @escaping(Bool) -> Void) {
        self.showTextError = false
        apiShared.sendEmailCode(email: registerStepEmail) { _ in
            comletition(true)
        }
        comletition(true)
    }
    
    func verifyCode(comletition: @escaping(Bool) -> Void) {
        self.showTextError = false
        apiShared.sendCodeToVerify(email: registerStepEmail, code: code) { response in
            if response.reason == "Code was wrong" {
                comletition(!response.error)
                withAnimation(.spring()) {
                    self.someError = response.error
                    self.showTextError = response.error
                }
            } else if response.reason == "Email_verify" {
                comletition(response.error)
            }
        }
    }
    
    private func checkUniqueNickname(comletition: @escaping(Bool) -> Void) {
        self.showTextError = false
        apiShared.checkUniqueNickname(nick: registerStepNickName) { response in
            if response.reason == "Nickname already exist" {
                comletition(!response.error)
                withAnimation(.spring()) {
                    self.loading = false
                    self.someError = response.error
                    self.nickAlreadyExists = response.error
                }
            } else if response.reason == "Nick free" {
                comletition(response.error)
            }
        }
    }
    
    private func sendRequestToRegistration() {
        var parametrs:[String:Any] = [:]
        parametrs["name"] = self.registerStepNickName
        parametrs["email"] = self.registerStepEmail
        parametrs["password"] = self.registerStepPassword
        self.apiShared.registration(parametrs: parametrs) { user in
            print(user.email)
            print(user.name)
            self.login_status = true
        } completitionError: { error in
            if error.error {
                withAnimation(.spring()) {
                    self.loading = false
                    self.someError = true
                    self.showTextError = true
                }
            }
        }
    }
    
    func signUp() {
        self.showTextError = false
        self.nickAlreadyExists = false
        
        checkUniqueNickname { bool in
            if bool {
                withAnimation(.spring()) {
                    self.loading = true
                }
                self.sendRequestToRegistration()
            } else {
                withAnimation(.spring()) {
                    self.loading = false
                    self.someError = true
                    self.showTextError = true
                }
            }
        }
    }
    
    func sigIn() {
        withAnimation(.spring()) {
            self.loading = true
        }
        self.showTextError = false
        self.someError = false
        var parametrs:[String:Any] = [:]
        parametrs["email"] = self.loginStepEmail
        parametrs["password"] = self.loginStepPassword
        apiShared.login(parametrs: parametrs) { user in
            withAnimation(.spring()) {
                self.login_status = true
            }
        } completitionError: { error in
            if error.error {
                withAnimation(.spring()) {
                    self.loading = false
                    self.someError = true
                    self.showTextError = true
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
}
