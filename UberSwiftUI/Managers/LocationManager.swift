//
//  LocationManager.swift
//  UberSwiftUI
//
//  Created by Maciej on 17/02/2023.
//

import CoreLocation

final class LocationManager: NSObject, ObservableObject {
    // MARK: - Properties
    @Published var userLocation: CLLocationCoordinate2D?
    static let shared = LocationManager()
    private let locationManager = CLLocationManager()
    
    // MARK: - Lifecycle
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        userLocation = location.coordinate
        locationManager.stopUpdatingLocation()
    }
}
