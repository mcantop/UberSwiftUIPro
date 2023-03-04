//
//  DriverAnnotation.swift
//  UberSwiftUI
//
//  Created by Maciej on 02/03/2023.
//

import Foundation
import MapKit
import Firebase

final class DriverAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    let uid: String
    
    init(driver: User) {
        self.coordinate = CLLocationCoordinate2D(latitude: driver.coordinates.latitude,
                                                 longitude: driver.coordinates.longitude)
        self.uid = driver.uid
    }
}
