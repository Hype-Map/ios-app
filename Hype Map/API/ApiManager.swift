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
}
