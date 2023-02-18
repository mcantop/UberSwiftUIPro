//
//  UberMapViewRepresentable.swift
//  UberSwiftUI
//
//  Created by Maciej on 17/02/2023.
//

import SwiftUI
import MapKit

struct UberMapViewRepresentable: UIViewRepresentable {
    // MARK: - Properties
    @EnvironmentObject var locationViewModel: LocationSearchViewModel
    let mapView = MKMapView()
    let locationManager = LocationManager()
    
    // MARK: - Helpers
    func makeUIView(context: Context) -> some UIView {
        mapView.delegate = context.coordinator
        mapView.isRotateEnabled = false
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        return mapView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        if let selectedLocation = locationViewModel.selectedLocation {
            print("DEBUG: Selected location in Map View is - \(selectedLocation)")
        }
    }
    
    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(parent: self)
    }
}

// MARK: - MKMapViewDelegate
extension UberMapViewRepresentable {
    final class MapCoordinator: NSObject, MKMapViewDelegate {
        let parent: UberMapViewRepresentable
        
        init(parent: UberMapViewRepresentable) {
            self.parent = parent
            super.init()
        }
        
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            let region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
            
            parent.mapView.setRegion(region, animated: true)
        }
    }
}
