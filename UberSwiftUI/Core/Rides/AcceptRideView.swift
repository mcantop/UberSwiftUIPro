//
//  AcceptTripView.swift
//  UberSwiftUI
//
//  Created by Maciej on 04/03/2023.
//

import SwiftUI
import MapKit

struct AcceptRideView: View {
    // MARK: - Properties
    @State private var coordinateRegion: MKCoordinateRegion
    
    init() {
        let center = CLLocationCoordinate2D(latitude: 37.3346, longitude: -122.0090)
        let span = MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025)
        
        self.coordinateRegion = MKCoordinateRegion(center: center, span: span)
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
                    Text("10")
                    
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
                    
                    Text("SUPER HENDRIX")
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
                    Text("Earnings:")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Text("$22.04")
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
                        Text("Apple Campus")
                        
                        Spacer()
                        
                        Text("5.2")
                    }
                    .font(.headline)
                    
                    HStack {
                        Text("Infinite Loop 1, Santa Clara County")
                        
                        Spacer()
                        
                        Text("km")
                    }
                    .font(.subheadline)
                    .foregroundColor(.gray)
                }
                
                Map(coordinateRegion: $coordinateRegion)
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
        AcceptRideView()
    }
}
