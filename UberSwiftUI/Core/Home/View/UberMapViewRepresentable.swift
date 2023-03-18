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
    @EnvironmentObject var homeViewModel: HomeViewModel
    @Binding var mapState: MapState
    let mapView = MKMapView()
    let locationManager = LocationManager.shared
    
    // MARK: - Helpers
    func makeUIView(context: Context) -> some UIView {
        mapView.delegate = context.coordinator
        mapView.isRotateEnabled = false
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        return mapView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        switch mapState {
        case .noInput:
            context.coordinator.clearMapViewRecenter()
            context.coordinator.addDriversToMap(homeViewModel.drivers)
        case .searchingForLocation, .polylineAdded:
            break
        case .locationSelected:
            if let coordinate = homeViewModel.selectedUberLocation?.coordinate {
                context.coordinator.addAndSelectAnnotation(coordinate: coordinate)
                context.coordinator.configurePolyline(destinationCoordinate: coordinate)
            }
        case .tripAccepted:
            guard let trip = homeViewModel.trip,
                  let route = homeViewModel.routeToPickupLocation,
                  let driver = homeViewModel.currentUser,
                  driver.accountType == .driver else { return }
            
            context.coordinator.configurePolylineToPickupLocation(route: route)
            context.coordinator.addAndSelectAnnotation(coordinate: trip.pickupLocation.toCoordinate())
        default:
            break
        }
    }
    
    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(parent: self)
    }
}

extension UberMapViewRepresentable {
    final class MapCoordinator: NSObject, MKMapViewDelegate {
        // MARK: - Properties
        let parent: UberMapViewRepresentable
        private var userLocationCoordinate: CLLocationCoordinate2D?
        private var currentRegion: MKCoordinateRegion?
        
        // MARK: - Lifecycle
        init(parent: UberMapViewRepresentable) {
            self.parent = parent
            super.init()
        }
        
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            userLocationCoordinate = userLocation.coordinate
            
            let region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
            
            currentRegion = region
            
            if parent.mapState != .polylineAdded {
                parent.mapView.setRegion(region, animated: true)
            }
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let polyline = MKPolylineRenderer(overlay: overlay)
            polyline.strokeColor = .systemBlue
            polyline.lineWidth = 6
            return polyline
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if let annotation = annotation as? DriverAnnotation {
                let view = MKAnnotationView(annotation: annotation, reuseIdentifier: "driver")
                let image = UIImage(named: "chevron-sign-to-right-2")
                view.image = image
                return view
            }
            
            return nil
        }
        
        // MARK: - Helpers
        func addAndSelectAnnotation(coordinate: CLLocationCoordinate2D) {
            /// Remove any potential annotations that could have been added before.
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            
            parent.mapView.addAnnotation(annotation)
            parent.mapView.selectAnnotation(annotation, animated: true)
            /// Changes MapView to fit user and annotation on a screen.
            //            parent.mapView.showAnnotations(parent.mapView.annotations, animated: true)
        }
        
        func configurePolyline(destinationCoordinate: CLLocationCoordinate2D) {
            guard let userLocationCoordinate = userLocationCoordinate else { return }
            
            parent.homeViewModel.getDestinationRoute(
                from: userLocationCoordinate,
                to: destinationCoordinate
            ) { route in
                self.parent.mapView.addOverlay(route.polyline)
                self.parent.mapState = .polylineAdded
                
                let rect = self.parent.mapView.mapRectThatFits(
                    route.polyline.boundingMapRect,
                    edgePadding: .init(top: 96, left: 32, bottom: 500, right: 32)
                )
                
                self.parent.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
            }
        }
        
        func clearMapViewRecenter() {
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            parent.mapView.removeOverlays(parent.mapView.overlays)
            
            if let currentRegion = currentRegion {
                parent.mapView.setRegion(currentRegion, animated: true)
            }
        }
        
        func configurePolylineToPickupLocation(route: MKRoute) {
            parent.mapView.addOverlay(route.polyline)
            
            let rect = parent.mapView.mapRectThatFits(
                route.polyline.boundingMapRect,
                edgePadding: .init(top: 96, left: 32, bottom: 400, right: 32)
            )
            
            parent.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
        
        func addDriversToMap(_ drivers: [User]) {
            let annotations = drivers.map { DriverAnnotation(driver: $0) }
            self.parent.mapView.addAnnotations(annotations)
        }
    }
}
