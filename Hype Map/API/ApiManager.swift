//
//  ApiManager.swift
//  Hype Map
//
//  Created by Артем Соловьев on 27.01.2023.
//

import Foundation
import Alamofire

enum ApiError: Error {
    case runtimeError(String)
}

enum IconWeather: String {
    case rain = "Rain"
    case snow = "Snow"
    case clouds = "Clouds"
    case sun = "Clear"
}

var url: String {
    "http://127.0.0.1:8080/"
}

var sendEmailUrl: String {
    "send_code"
}

var checkNick: String {
    "check_nick"
}

var registrationUrl: String {
    "registration"
}

var loginUrl: String {
    "login"
}

final class ApiManager {
    static let shared = ApiManager()
    
    func getWeather(lat: Double, lon: Double, completition: @escaping(WeatherModels) -> Void)  {
        let mainUrl = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=b64609ea85af95e1f07474d8e6ed03e5&units=metric"
        AF.request(mainUrl).response { responseData in
            guard let data = responseData.data else { return }
            if let weather = try? JSONDecoder().decode(WeatherModels.self, from: data) {
                completition(weather)
            } else {
                print(ApiError.runtimeError("Parse error"))
            }
        }
    }
    
    func sendEmailCode(email: String, completition: @escaping(BaseResponse) -> Void) {
        AF.request(url + sendEmailUrl + "/" + email, method: .post).response { responseData in
            guard let data = responseData.data else { return }
            if let email = try? JSONDecoder().decode(BaseResponse.self, from: data) {
                completition(email)
            } else {
                print(ApiError.runtimeError("Parse error"))
            }
        }
    }
    
    func sendCodeToVerify(email: String, code: String, completition: @escaping(BaseResponse) -> Void) {
        AF.request(url + sendEmailUrl + "/" + email + "/" + code, method: .post).response { responseData in
            guard let data = responseData.data else { return }
            if let email = try? JSONDecoder().decode(BaseResponse.self, from: data) {
                completition(email)
            } else {
                print(ApiError.runtimeError("Parse error"))
            }
        }
    }
    
    func checkUniqueNickname(nick: String, completition: @escaping(BaseResponse) -> Void) {
        AF.request(url + checkNick + "/" + nick, method: .post).response { responseData in
            guard let data = responseData.data else { return }
            if let email = try? JSONDecoder().decode(BaseResponse.self, from: data) {
                completition(email)
            } else {
                print(ApiError.runtimeError("Parse error"))
            }
        }
    }
    
    func registration(parametrs: [String:Any], completition: @escaping(User) -> Void) {
        AF.request(url + registrationUrl, method: .post, parameters: parametrs).response { responseData in
            guard let data = responseData.data else { return }
            if let user = try? JSONDecoder().decode(User.self, from: data) {
                completition(user)
            }
        }
    }
    
    func login(parametrs: [String:Any], completition: @escaping(User) -> Void) {
        AF.request(url + loginUrl, method: .post, parameters: parametrs).response { responseData in
            guard let data = responseData.data else { return }
            if let user = try? JSONDecoder().decode(User.self, from: data) {
                completition(user)
            }
        }
    }
}
