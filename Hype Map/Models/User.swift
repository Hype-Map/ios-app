//
//  User.swift
//  Hype Map
//
//  Created by Артем Соловьев on 15.02.2023.
//

import Foundation

final class User: Decodable {
    var email: String
    var name: String
    var password: String
    var id: String
    var accesToken: String
}
