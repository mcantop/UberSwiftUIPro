//
//  Ride.swift
//  UberSwiftUI
//
//  Created by Maciej on 05/03/2023.
//

import Foundation
import Firebase

struct Trip: Identifiable, Codable {
    let id: String
    let passengerUID: String
    let driverUID: String
    
    let passengerName: String
    let driverName: String
    
    let driverLocation: GeoPoint
    let passengerLocation: GeoPoint
    
    let pickupLocationName: String
    let dropoffLocationName: String
    let pickupLocation: GeoPoint
    let dropoffLocation: GeoPoint
    
    let pickupLocationAddress: String
    
    let rideCost: Double
    
    var distanceToPassenger: Double
    var travelTimeToPassenger: Int
}
