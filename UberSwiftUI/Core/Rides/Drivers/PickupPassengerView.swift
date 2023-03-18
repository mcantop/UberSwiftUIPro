//
//  PickupPassengerView.swift
//  UberSwiftUI
//
//  Created by Maciej on 18/03/2023.
//

import SwiftUI

struct PickupPassengerView: View {
    // MARK: - Properties
    @Environment(\.colorScheme) var scheme
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 16) {
            Spacer().frame(height: 0) // Top Padding
            
            // MARK: - Meet Your Driver...
            HStack {
                Group {
                    Text("Meet your passenger at ") +
                    Text(homeViewModel.trip?.pickupLocationName ?? "pickupLocationName").fontWeight(.semibold) +
                    Text(" for his trip to ") +
                    Text(homeViewModel.trip?.dropoffLocationName ?? "dropoffLocationName").fontWeight(.semibold) +
                    Text(".")
                }
                .font(.callout)
                .frame(height: 44)
                
                Spacer()
                
                VStack {
                    Text("\(10)")
                    
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
            HStack {
                Image("Future")
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: 64, height: 64)
                
                VStack(alignment: .leading, spacing: 0) {
                    Spacer()
                    
                    Text(homeViewModel.trip?.passengerName ?? "passengerName")
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
                    
                    Text((homeViewModel.trip?.rideCost ?? 0.0).toCurrency())
                        .font(.title)
                        .fontWeight(.semibold)
                }
            }
            .padding(.horizontal)
            
            Divider()
            
            UberWideButton(
                "Cancel Trip".uppercased(),
                buttonTextColor: .white,
                buttonBackgroundColor: .red
            ) {
                
            }
            .padding(.horizontal)
        }
        .padding(.bottom, 36)
        .frame(maxWidth: .infinity)
        .background(scheme == .light ? .white : Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct PickupPassengerView_Previews: PreviewProvider {
    static var previews: some View {
        PickupPassengerView()
    }
}
