//
//  LocationSearchViewModel.swift
//  UberSwiftUI
//
//  Created by Maciej on 18/02/2023.
//

import Foundation
import MapKit

enum LocationResultsViewConfig {
    case ride
    case saveLocation
}

final class LocationSearchViewModel: NSObject, ObservableObject {
    // MARK: - Properties
    @Published var results = [MKLocalSearchCompletion]()
    @Published var selectedUberLocation: UberLocation?
    @Published var pickupTime: String?
    @Published var dropOffTime: String?
    
    var userLocation: CLLocationCoordinate2D?
    var queryFragment = "" {
        didSet {
            guard !queryFragment.isEmpty else {
                /// Clear search result if no text inside textfield.
                results = []
                return
            }
            
            searchCompleter.queryFragment = queryFragment
        }
    }
    
    private let searchCompleter = MKLocalSearchCompleter()
    
    // MARK: - Lifecycle
    override init() {
        super.init()
        searchCompleter.delegate = self
        searchCompleter.queryFragment = queryFragment
    }
}

// MARK: - Public Helpers
extension LocationSearchViewModel {
    func selectLocation(_ localSearch: MKLocalSearchCompletion, config: LocationResultsViewConfig) {
        switch config {
        case .ride:
            searchForLocalSearchCompletion(localSearch) { response, error in
                if let error = error {
                    print("DEBUG: Location search failed with error - \(error.localizedDescription)")
                    return
                }
                guard let item = response?.mapItems.first else { return }
                let coordinate = item.placemark.coordinate
                self.selectedUberLocation = UberLocation(
                    title: localSearch.title,
                    coordinate: coordinate
                )
            }
        case .saveLocation:
            print("DEBUG: Save location here..")
        }
    }
    
    func searchForLocalSearchCompletion(_ localSearch: MKLocalSearchCompletion, completionHandler: @escaping MKLocalSearch.CompletionHandler) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = localSearch.title.appending(localSearch.subtitle)
        
        let search = MKLocalSearch(request: request)
        search.start(completionHandler: completionHandler)
    }
    
    func calculateRidePrice(type: RideType) -> Double {
        guard let destinationCoordinate = selectedUberLocation?.coordinate else { return 0.0 }
        guard let userCoordinate = userLocation else { return 0.0 }
        
        let startingLocation = CLLocation(
            latitude: userCoordinate.latitude,
            longitude: userCoordinate.longitude
        )
        
        let destination = CLLocation(
            latitude: destinationCoordinate.latitude,
            longitude: destinationCoordinate.longitude
        )
        
        let distanceInMeters = startingLocation.distance(from: destination)
        return type.computePrice(distanceInMeters: distanceInMeters)
    }
    
    func getDestinationRoute(from userLocation: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D, completion: @escaping(MKRoute) -> Void) {
        let userPlacemark = MKPlacemark(coordinate: userLocation)
        let destinationPlacemark = MKPlacemark(coordinate: destination)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: userPlacemark)
        request.destination = MKMapItem(placemark: destinationPlacemark)
        
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            if let error = error {
                print("DEBUG: Failed to get directions with error - \(error.localizedDescription)")
                return
            }
            
            guard let route = response?.routes.first else { return }
            self.configureTimes(expectedTravelTime: route.expectedTravelTime)
            completion(route)
        }
    }
    
    func configureTimes(expectedTravelTime: Double) {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        
        let now = Date()
        pickupTime = formatter.string(from: now)
        dropOffTime = formatter.string(from: now + expectedTravelTime)
    }
}

// MARK: - MKLocalSearchCompleterDelegate
extension LocationSearchViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results
    }
}
