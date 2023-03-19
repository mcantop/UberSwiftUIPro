//
//  HomeViewModel.swift
//  UberSwiftUI
//
//  Created by Maciej on 25/02/2023.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift
import Combine
import MapKit

final class HomeViewModel: NSObject, ObservableObject {
    // MARK: - Properties
    @Published var drivers = [User]()
    @Published var trip: Trip?
    private let userService = UserSerivce.shared
    private var cancellables = Set<AnyCancellable>()
    var currentUser: User?
    var routeToPickupLocation: MKRoute?
    
    // MARK: - Location Search Properties
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
    
    // MARK: - Init
    override init() {
        super.init()
        
        fetchUser()
        
        searchCompleter.delegate = self
        searchCompleter.queryFragment = queryFragment
    }
}

// MARK: - Helpers
extension HomeViewModel {
    func fetchUser() {
        userService.$user
            .sink { user in
                self.currentUser = user
                guard let user = user else { return }
                
                if user.accountType == .passenger {
                    self.fetchDrivers()
                    self.addTripObserverForPassenger()
                } else {
                    self.addTripObserverForDriver()
                }
            }
            .store(in: &cancellables)
    }
    
    func viewForState(_ state: MapState, user: User) -> some View {
        let isPassenger = user.accountType == .passenger
        
        switch state {
        case .tripRequested:
            guard isPassenger else { return AnyView(Text("")) }
            return AnyView(RideLoadingView())
        case .tripAccepted:
            return isPassenger ? AnyView(RideAcceptedView()) : AnyView(PickupPassengerView())
        case .tripCancelledByPassenger,
                .tripCancelledByDriver:
            return AnyView(RideCancelledView())
        default:
            break
        }
        
        return AnyView(Text(""))
    }
    
    func deleteTrip() {
        guard let trip = trip else { return }
        
        Firestore.firestore().collection("trips").document(trip.id).delete { _ in
            self.trip = nil
        }
    }
    
    private func updateTripState(state: TripState) {
        guard let trip = trip else { return }
        
        var data = ["state": state.rawValue]
        
        if state == .accepted {
            data["travelTimeToPassenger"] = trip.travelTimeToPassenger
        }
        
        Firestore.firestore().collection("trips").document(trip.id).updateData(data) { _ in
            print("DEBUG: Did update trip with state: \(state)..")
        }
    }
    
    var tripCancelledMessage: String {
        guard let user = currentUser,
              let trip = trip else { return "" }
        
        if user.accountType == .passenger {
            if trip.state == .driverCancelled {
                return "Your driver has cancelled this trip."
            } else if trip.state == .passengerCancelled {
                return "You cancelled this trip."
            }
        } else {
            if trip.state == .driverCancelled {
                return "You cancelled this trip."
            } else if trip.state == .passengerCancelled {
                return "Your passenger has cancelled this trip."
            }
        }
        
        return ""
    }
}

// MARK: - Passenger API
extension HomeViewModel {
    func fetchDrivers() {
        Firestore.firestore().collection("users")
            .whereField("accountType", isEqualTo: AccountType.driver.rawValue)
            .getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents else { return }
                let drivers = documents.compactMap({ try?  $0.data(as: User.self) })
                self.drivers = drivers
            }
    }
    
    func requestTrip() {
        guard let driver = drivers.first,
              let currentUser = currentUser,
              let dropoffLocation = selectedUberLocation else {
            return
        }
        
        let dropoffGeoPoint = GeoPoint(
            latitude: dropoffLocation.coordinate.latitude,
            longitude: dropoffLocation.coordinate.longitude
        )
        
        let userLocation = CLLocation(
            latitude: currentUser.coordinates.latitude,
            longitude: currentUser.coordinates.longitude
        )
        
        print("DEBUG: Driver is \(driver.fullname)")
        print("DEBUG: Passenger is \(currentUser.fullname)")
        print("DEBUG: Dropoff location is \(dropoffLocation.title)")
        
        getPlacemarkFrom(location: userLocation) { placemark, _ in
            guard let placemark = placemark else { return }
            
            let rideCost = self.calculateRidePrice(type: .uberX)
            let pickupLocationAddress = self.addressFromPlacemark(placemark)
            
            let trip = Trip(
                passengerUID: currentUser.uid,
                driverUID: driver.uid,
                passengerName: currentUser.fullname,
                driverName: driver.fullname,
                driverLocation: driver.coordinates,
                passengerLocation: currentUser.coordinates,
                pickupLocationName: placemark.name ?? "Current Location",
                dropoffLocationName: dropoffLocation.title,
                pickupLocation: currentUser.coordinates,
                dropoffLocation: dropoffGeoPoint,
                pickupLocationAddress: pickupLocationAddress,
                rideCost: rideCost,
                distanceToPassenger: 0,
                travelTimeToPassenger: 0,
                state: .requested
            )
            
            print("DEBUG: Trip is \(trip)")
            
            guard let encodedTrip = try? Firestore.Encoder().encode(trip) else { return }
            Firestore.firestore().collection("trips").document().setData(encodedTrip) { _ in
                print("DEBUG: Did upload trip to firebase")
            }
        }
    }
    
    func addTripObserverForPassenger() {
        guard let currentUser = currentUser,
              currentUser.accountType == .passenger else { return }
        
        Firestore.firestore().collection("trips").whereField("passengerUID", isEqualTo: currentUser.uid)
            .addSnapshotListener { snapshot, _ in
                guard let change = snapshot?.documentChanges.first,
                      change.type == .added || change.type == .modified else { return }
                
                guard let trip = try? change.document.data(as: Trip.self) else { return }
                self.trip = trip
                print("DEBUG: Updated trip state is \(trip.state)")
            }
    }
    
    func cancelTripAsPassenger() {
        updateTripState(state: .passengerCancelled)
    }
}

// MARK: - Driver API
extension HomeViewModel {
    func cancelTripAsDriver() {
        updateTripState(state: .driverCancelled)
    }
    
    func rejectTrip() {
        updateTripState(state: .rejected)
    }
    
    func acceptTrip() {
        updateTripState(state: .accepted)
    }
    
    func addTripObserverForDriver() {
        guard let currentUser = currentUser,
              currentUser.accountType == .driver else { return }
        
        Firestore.firestore().collection("trips").whereField("driverUID", isEqualTo: currentUser.uid)
            .addSnapshotListener { snapshot, _ in
                guard let change = snapshot?.documentChanges.first,
                      change.type == .added || change.type == .modified else { return }
                
                guard let trip = try? change.document.data(as: Trip.self) else { return }
                self.trip = trip
                self.getDestinationRoute(
                    from: trip.driverLocation.toCoordinate(),
                    to: trip.pickupLocation.toCoordinate()
                ) { route in
                    let travelTimeToPassenger = Int(route.expectedTravelTime / 60)
                    let distanceToPassenger = route.distance.distanceInKilometeresString()
                    
                    self.routeToPickupLocation = route
                    self.trip?.travelTimeToPassenger = travelTimeToPassenger
                    self.trip?.distanceToPassenger = route.distance
                    
                    print("DEBUG: Expected travel time to passenger \(travelTimeToPassenger) min")
                    print("DEBUG: Distance to passenger \(distanceToPassenger) km")
                }
            }
    }
}

// MARK: - LocationSearch Helpers
extension HomeViewModel {
    func getPlacemarkFrom(location: CLLocation, completion: @escaping(CLPlacemark?, Error?) -> Void) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let placemark = placemarks?.first else { return }
            completion(placemark, nil)
        }
    }
    
    func selectLocation(_ localSearch: MKLocalSearchCompletion, config: LocationResultsConfig) {
        searchForLocalSearchCompletion(localSearch) { response, error in
            if let error = error {
                print("DEBUG: Location search failed with error - \(error.localizedDescription)")
                return
            }
            guard let item = response?.mapItems.first else { return }
            let coordinate = item.placemark.coordinate
            
            switch config {
            case .ride:
                self.selectedUberLocation = UberLocation(
                    title: localSearch.title,
                    coordinate: coordinate
                )
            case .saveLocation(let viewModel):
                guard let uid = Auth.auth().currentUser?.uid else { return }
                let favoriteLocation = FavoriteLocation(
                    title: localSearch.title,
                    address: localSearch.subtitle,
                    coordinates: GeoPoint(latitude: coordinate.latitude, longitude: coordinate.longitude)
                )
                guard let encodedLocation = try? Firestore.Encoder().encode(favoriteLocation) else { return }
                
                Firestore.firestore().collection("users").document(uid).updateData([
                    viewModel.databaseKey: encodedLocation
                ])
                
                print("DEBUG: Successfully saved user \(viewModel.title) location - \(localSearch.title)")
            }
            
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
    
    func addressFromPlacemark(_ placemark: CLPlacemark) -> String {
        var result = ""
        
        if let thoroughfare = placemark.thoroughfare {
            result += thoroughfare
        }
        
        if let subThoroughfare = placemark.subThoroughfare {
            result += " \(subThoroughfare)"
        }
        
        if let subAdministrativeArea = placemark.subAdministrativeArea {
            result += ", \(subAdministrativeArea)"
        }
        
        return result
    }
}

// MARK: - MKLocalSearchCompleterDelegate
extension HomeViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results
    }
}
