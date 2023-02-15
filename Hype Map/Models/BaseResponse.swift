//
//  BaseResponse.swift
//  Hype Map
//
//  Created by Артем Соловьев on 15.02.2023.
//

import Foundation

final class BaseResponse: Decodable {
    var error: Bool
    var reason: String
}
