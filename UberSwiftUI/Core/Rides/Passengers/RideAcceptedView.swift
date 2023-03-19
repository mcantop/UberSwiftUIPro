//
//  RideAcceptedView.swift
//  UberSwiftUI
//
//  Created by Maciej on 17/03/2023.
//

import SwiftUI

struct RideAcceptedView: View {
    @Environment(\.colorScheme) var scheme
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer().frame(height: 0) // Top Padding
            
            // MARK: - Meet Your Driver...
            HStack {
                Group {
                    Text("Meet your driver at ") +
                    Text(homeViewModel.trip?.pickupLocationName ?? "pickupLocationName").fontWeight(.semibold) +
                    Text(" for your trip to ") +
                    Text(homeViewModel.trip?.dropoffLocationName ?? "dropoffLocationName").fontWeight(.semibold) +
                    Text(".")
                }
                .font(.callout)
                .frame(height: 44)
                
                Spacer()
                
                VStack {
                    Text("\(homeViewModel.trip?.travelTimeToPassenger ?? 10)")
                    
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
            
            // MARK: - Driver & Car Info
            HStack(alignment: .top) {
                Image("Future")
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: 64, height: 64)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(homeViewModel.trip?.driverName ?? "driverName")
                        .font(.headline)
                        .lineLimit(2)
                    
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        
                        Text("4.8")
                            .foregroundColor(.gray)
                    }
                    .font(.footnote)
                    
                }
                .frame(height: 64)
                
                Spacer()
                
                // MARK: - Driver Vehicle Info
                VStack(spacing: 0) {
                    Image("uber-x")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 40)
                    
                    Text("Tesla")
                        .font(.headline)
                    Text("GO-ELON")
                        .font(.caption)
                }
            }
            .padding(.horizontal)
            
            Divider()
            
            UberWideButton(
                "Cancel Trip".uppercased(),
                buttonTextColor: .white,
                buttonBackgroundColor: .red
            ) {
                homeViewModel.cancelTripAsPassenger()
            }
            .padding(.horizontal)
        }
        .padding(.bottom, 36)
        .frame(maxWidth: .infinity)
        .background(
            scheme == .light ? .white : Color(.systemGray6)
        )
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct RideAcceptedView_Previews: PreviewProvider {
    static var previews: some View {
        RideAcceptedView()
            .environmentObject(HomeViewModel())
    }
}
