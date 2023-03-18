//
//  MapViewActionButton.swift
//  UberSwiftUI
//
//  Created by Maciej on 17/02/2023.
//

import SwiftUI

struct MapViewActionButton: View {
    // MARK: - Properties
    @Environment(\.colorScheme) var scheme
    @EnvironmentObject var homeViewModel: HomeViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @Binding var mapState: MapState
    @Binding var showingSideMenu: Bool
    
    // MARK: - Body
    var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.25)) {
                actionForState(mapState)
            }
        } label: {
            Image(systemName: imageNameForState(mapState))
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .frame(width: 50, height: 50)
                .background(Color(.systemGray6))
                .overlay(
                    Circle().stroke(Color(.systemGray4), lineWidth: 2)
                )
                .clipShape(Circle())
        }
    }
}

// MARK: - Private Helpers
private extension MapViewActionButton {
    func actionForState(_ state: MapState) {
        switch state {
        case .noInput:
            showingSideMenu.toggle()
        case .searchingForLocation:
            mapState = .noInput
        case .locationSelected,
                .polylineAdded,
                .tripRequested,
                .tripRejected,
                .tripAccepted:
            mapState = .noInput
            homeViewModel.selectedUberLocation = nil
        }
    }
    
    func imageNameForState(_ state: MapState) -> String {
        switch state {
        case .noInput:
            return "line.3.horizontal"
        case .searchingForLocation,
                .locationSelected,
                .tripRequested,
                .tripRejected,
                .tripAccepted:
            return "arrow.left"
        default:
            return "line.3.horizontal"
        }
    }
}

struct MapViewActionButton_Previews: PreviewProvider {
    static var previews: some View {
        MapViewActionButton(mapState: .constant(.noInput), showingSideMenu: .constant(false))
            .environmentObject(HomeViewModel())
    }
}
