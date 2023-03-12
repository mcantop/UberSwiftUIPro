//
//  AcceptTripView.swift
//  UberSwiftUI
//
//  Created by Maciej on 04/03/2023.
//

import SwiftUI
import MapKit

struct RideAcceptView: View {
    // MARK: - Properties
    @State private var coordinateRegion: MKCoordinateRegion
    private let trip: Trip
    private let annotationItem: UberLocation
    
    // MARK: - Init
    init(trip: Trip) {
        self.trip = trip
        let center = CLLocationCoordinate2D(latitude: trip.pickupLocation.latitude,
                                            longitude: trip.pickupLocation.longitude)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.025,
                                    longitudeDelta: 0.025)
        
        self.coordinateRegion = MKCoordinateRegion(center: center, span: span)
        self.annotationItem = UberLocation(title: trip.pickupLocationName,
                                           coordinate: trip.pickupLocation.toCoordinate())
    }
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 16) {
            // MARK: - Pick Up View
            HStack {
                Text("Would you like to pick up this passenger?")
                    .font(.headline)
                    .frame(height: 44)
                    .lineLimit(2)
                
                Spacer()
                
                VStack {
                    Text("\(trip.travelTimeToPassenger)")
                    
                    Text("min")
                }
                .fontWeight(.semibold)
                .padding(8)
                .foregroundColor(.white)
                .background(.blue)
                .cornerRadius(10)
            }
            .padding(.horizontal)
            
            Divider()
            
            // MARK: - User & Earnings View
            HStack {
                Image("Future")
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: 64, height: 64)
                
                VStack(alignment: .leading, spacing: 0) {
                    Spacer()
                    
                    Text(trip.passengerName)
                        .font(.headline)
                    
                    Spacer()
                    
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        
                        Text("4.8")
                            .foregroundColor(.gray)
                    }
                    .font(.footnote)
                    
                    Spacer()
                }
                .frame(height: 64)
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("Earnings")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Text(trip.rideCost.toCurrency())
                        .font(.title)
                        .fontWeight(.semibold)
                }
            }
            .padding(.horizontal)
            
            Divider()
            
            // MARK: - Map View
            VStack(spacing: 16) {
                VStack(spacing: 4) {
                    HStack {
                        Text(trip.pickupLocationName)
                        
                        Spacer()
                        
                        Text(trip.distanceToPassenger.distanceInKilometeresString())
                    }
                    .font(.headline)
                    
                    HStack {
                        Text(trip.pickupLocationAddress)
                        
                        Spacer()
                        
                        Text("km")
                    }
                    .font(.subheadline)
                    .foregroundColor(.gray)
                }
                
                Map(coordinateRegion: $coordinateRegion, annotationItems: [annotationItem]) { item in
                    MapMarker(coordinate: item.coordinate)
                }
                .frame(height: 220)
                .cornerRadius(10)
                .shadow(radius: 5)
            }
            .padding(.horizontal)
            
            Divider()
            
            HStack(spacing: 16) {
                Button {
                    
                } label: {
                    Text("Reject")
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding()
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .background(.red)
                        .cornerRadius(10)
                }
                
                Button {
                    
                } label: {
                    Text("Accept")
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding()
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .background(.blue)
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal)
        }
    }
}

struct AcceptTripView_Previews: PreviewProvider {
    static var previews: some View {
        RideAcceptView(trip: dev.mockTrip)
    }
}
