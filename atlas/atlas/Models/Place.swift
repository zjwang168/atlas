//
//  Place.swift
//  atlas
//
//  Created by Zijin Wang on 5/18/26.
//

import Foundation
import CoreLocation

struct Place: Identifiable {
    let id = UUID()
    let name: String
    let subtitle: String
    let summary: String
    let latitude: Double
    let longitude: Double
    let tags: [String]

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
