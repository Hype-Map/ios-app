//
//  WeatherModels.swift
//  Hype Map
//
//  Created by Артем Соловьев on 27.01.2023.
//

import Foundation

class WeatherModels: Codable {
    var weather: [Weather]
    var main: Main
}

class Main: Codable {
    var temp: Float
}

class Weather: Codable {
    var main: String
}
