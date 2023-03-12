//
//  GeoPoint+Extension.swift
//  UberSwiftUI
//
//  Created by Maciej on 05/03/2023.
//

import Foundation
import Firebase
import CoreLocation

extension GeoPoint {
    func toCoordinate() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
}
