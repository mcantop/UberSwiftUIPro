//
//  DeveloperPreview.swift
//  UberSwiftUI
//
//  Created by Maciej on 25/02/2023.
//

import SwiftUI
import Firebase

extension PreviewProvider {
    static var dev: DeveloperPrevier {
        return DeveloperPrevier.shared
    }
}

final class DeveloperPrevier {
    static let shared = DeveloperPrevier()
    
    let mockUser = User(
        fullname: "Future",
        email: "future@mail.com",
        uid: NSUUID().uuidString,
        coordinates: GeoPoint(latitude: 37.38, longitude: -122.05),
        accountType: .passenger
    )
    
    let mockTrip = Trip(
        id: UUID().uuidString,
        passengerUID: UUID().uuidString,
        driverUID: UUID().uuidString,
        passengerName: "Passenger Name",
        driverName: "Driver Name",
        driverLocation: .init(latitude: 37.123, longitude: -122.1),
        passengerLocation: .init(latitude: 37.123, longitude: -122.1),
        pickupLocationName: "Apple Campus",
        dropoffLocationName: "Starbucks",
        pickupLocation: .init(latitude: 37.456, longitude: -122.15),
        dropoffLocation: .init(latitude: 37.042, longitude: -122.2),
        pickupLocationAddress: "123 Main St, Palo Alto CA",
        rideCost: 47,
        distanceToPassenger: 1000,
        travelTimeToPassenger: 24
    )
}
