//
//  Location.swift
//  Hype Map
//
//  Created by Артем Соловьев on 24.01.2023.
//

import Foundation
import MapKit

struct Location: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}
