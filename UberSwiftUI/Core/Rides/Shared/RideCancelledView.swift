//
//  RideCancelledView.swift
//  UberSwiftUI
//
//  Created by Maciej on 19/03/2023.
//

import SwiftUI

struct RideCancelledView: View {
    // MARK: - Properties
    @Environment(\.colorScheme) var scheme
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    // MARK: - Body
    var body: some View {
        VStack {
            Text(homeViewModel.tripCancelledMessage)
                .font(.headline)
                .padding(.top)
            
            UberWideButton("Close", buttonTextColor: .white, buttonBackgroundColor: .blue) {
                guard let user = homeViewModel.currentUser,
                      let trip = homeViewModel.trip else { return }
                
                if user.accountType == .passenger {
                    if trip.state == .driverCancelled {
                        homeViewModel.deleteTrip()
                    } else if trip.state == .passengerCancelled {
                        homeViewModel.trip = nil
                    }
                } else {
                    if trip.state == .passengerCancelled {
                        homeViewModel.deleteTrip()
                    } else if trip.state == .driverCancelled {
                        homeViewModel.trip = nil
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.bottom, 36)
        .frame(maxWidth: .infinity)
        .background(scheme == .light ? .white : Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct RideCancelledView_Previews: PreviewProvider {
    static var previews: some View {
        RideCancelledView()
    }
}
