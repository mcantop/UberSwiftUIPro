//
//  UberLocation.swift
//  UberSwiftUI
//
//  Created by Maciej on 20/02/2023.
//

import CoreLocation

struct UberLocation: Identifiable {
    let id = UUID().uuidString
    let title: String
    let coordinate: CLLocationCoordinate2D
}
