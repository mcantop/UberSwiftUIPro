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
    @Published var selectedLocation: String?
    
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
    func selectLocation(_ location: String) {
        self.selectedLocation = location
        print("DEBUG: Selected location - \(selectedLocation ?? "No Location Found")")
    }
}

// MARK: - MKLocalSearchCompleterDelegate
extension LocationSearchViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results
    }
}
