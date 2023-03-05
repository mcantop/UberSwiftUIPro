//
//  UberCardView.swift
//  UberSwiftUI
//
//  Created by Maciej on 19/02/2023.
//

import SwiftUI

struct UberCardView: View {
    // MARK: - Properties
    @Environment(\.colorScheme) var scheme
    @EnvironmentObject var homeViewModel: HomeViewModel
    @Binding var selectedRideType: RideType
    let rideType: RideType
    
    private var isSelected: Bool {
        return selectedRideType == rideType
    }
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            Image(rideType.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .scaleEffect(isSelected ? 1.3 : 1.1)
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 6) {
                Text(rideType.description)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
                    .scaleEffect(isSelected ? 1.1 : 1)
                
                Text(homeViewModel.calculateRidePrice(type: rideType).toCurrency())
                    .font(.subheadline)
                    .fontWeight(.thin)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 50)
            .padding(12)
        }
        .foregroundColor(isSelected ? scheme == .light ? .white : .black : .primary)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .frame(height: isSelected ? 125 : 115)
        .background(
            isSelected ? .blue : .gray.opacity(0.3)
        )
        .cornerRadius(12)
        .onTapGesture {
            withAnimation(.spring()) {
                selectedRideType = rideType
            }
        }
    }
}

struct UberCardView_Previews: PreviewProvider {
    static var previews: some View {
        UberCardView(selectedRideType: .constant(.uberX), rideType: .uberX)
            .environmentObject(HomeViewModel())
    }
}
