//
//  RideRequestView.swift
//  UberSwiftUI
//
//  Created by Maciej on 19/02/2023.
//

import SwiftUI

struct RideRequestView: View {
    // MARK: - Properties
    @Environment(\.colorScheme) var scheme
    @EnvironmentObject var locationViewModel: LocationSearchViewModel
    @State private var selectedRideType: RideType = .uberX
    private let rows = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible())
    ]
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 8) {
            // MARK: - Ride Details
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Spacer(minLength: 0).frame(width: 12)
                    
                    VStack(alignment: .center, spacing: 5) {
                        Circle()
                            .fill(.gray)
                            .frame(width: 8, height: 8)
                        
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.gray)
                            .frame(width: 2, height: 44)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .frame(width: 10, height: 10)
                    }
                    .frame(width: 50, height: 100)
                    
                    Spacer(minLength: 0).frame(width: 12)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Current location")
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                            
                            Text(locationViewModel.pickupTime ?? "")
                        }
                        .foregroundColor(.gray)
                        
                        Spacer()
                        
                        HStack {
                            Text(locationViewModel.selectedUberLocation?.title ?? "")
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                            
                            Text(locationViewModel.dropOffTime ?? "")
                        }
                        .fontWeight(.semibold)
                    }
                    .frame(height: 100)
                    
                    Spacer(minLength: 0).frame(width: 12)
                }
            }
            
            Divider()
            
            // MARK: - Suggested Rides Cards
            VStack(spacing: 8) {
                Text("Suggested Rides".uppercased())
                    .font(.headline)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                LazyVGrid(columns: rows) {
                    ForEach(RideType.allCases) { rideType in
                        UberCardView(
                            selectedRideType: $selectedRideType,
                            rideType: rideType
                        )
                    }
                }
                .padding(.horizontal)
            }
            
            Divider()
            
            // MARK: - Credit Card
            Button {
                print("DEBUG: Credit Card button tapped..")
            } label: {
                HStack(spacing: 0) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.primary)
                            .frame(width: 75)
                        
                        Text("VISA")
                            .fontWeight(.bold)
                            .foregroundColor(scheme == .light ? .white : .black)
                    }
                    .padding(8)
                    
                    Text("**** 1234")
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal, 8)
                .foregroundColor(scheme == .light ? .black : .white)
                .fontWeight(.semibold)
                .frame(height: 50)
            }
            .background(.gray.opacity(0.3))
            .cornerRadius(12)
            .padding(.horizontal)
            
            Divider()
            
            // MARK: - Confirm Button
            Button {
                print("DEBUG: Confirm Ride button pressed..")
            } label: {
                Text("Confirm Ride".uppercased())
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(.blue)
                    .cornerRadius(12)
                    .padding(.horizontal)
            }
        }
        .padding(.vertical)
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct RideRequestView_Previews: PreviewProvider {
    static var previews: some View {
        RideRequestView()
            .environmentObject(LocationSearchViewModel())
    }
}
