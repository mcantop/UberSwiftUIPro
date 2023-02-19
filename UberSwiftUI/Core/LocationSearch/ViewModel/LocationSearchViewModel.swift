//
//  LocationSearchViewModel.swift
//  UberSwiftUI
//
//  Created by Maciej on 18/02/2023.
//

import Foundation
import MapKit

final class LocationSearchViewModel: NSObject, ObservableObject {
    // MARK: - Properties
    @Published var results = [MKLocalSearchCompletion]()
    @Published var selectedCoordinate: CLLocationCoordinate2D?
    
    var queryFragment = "" {
        didSet {
            guard !queryFragment.isEmpty else {
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
    func selectLocation(_ localSearch: MKLocalSearchCompletion) {
        searchForLocalSearchCompletion(localSearch) { response, error in
            if let error = error {
                print("DEBUG: Location search failed with error - \(error.localizedDescription)")
                return
            }
            guard let item = response?.mapItems.first else { return }
            let coordinate = item.placemark.coordinate
            self.selectedCoordinate = coordinate
        }
    }
    
    func searchForLocalSearchCompletion(_ localSearch: MKLocalSearchCompletion, completionHandler: @escaping MKLocalSearch.CompletionHandler) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = localSearch.title.appending(localSearch.subtitle)
        
        let search = MKLocalSearch(request: request)
        search.start(completionHandler: completionHandler)
    }
}

// MARK: - MKLocalSearchCompleterDelegate
extension LocationSearchViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results
    }
}
