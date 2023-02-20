//
//  MapViewActionButton.swift
//  UberSwiftUI
//
//  Created by Maciej on 17/02/2023.
//

import SwiftUI

struct MapViewActionButton: View {
    // MARK: - Properties
    @EnvironmentObject var locationViewModel: LocationSearchViewModel
    @Environment(\.colorScheme) var scheme
    @Binding var mapState: MapState
    
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
                .background(scheme == .light ? .white : .black)
                .capsuleOverlay()
                .clipShape(Circle())
        }
    }
}

// MARK: - Private Helpers
private extension MapViewActionButton {
    func actionForState(_ state: MapState) {
        switch state {
        case .noInput:
            break
        case .searchingForLocation:
            mapState = .noInput
        case .locationSelected, .polylineAdded:
            mapState = .noInput
            locationViewModel.selectedUberLocation = nil
        }
    }
    
    func imageNameForState(_ state: MapState) -> String {
        switch state {
        case .noInput:
            return "line.3.horizontal"
        case .searchingForLocation,
                .locationSelected:
            return "arrow.left"
        default:
            return "line.3.horizontal"
        }
    }
}

struct MapViewActionButton_Previews: PreviewProvider {
    static var previews: some View {
        MapViewActionButton(mapState: .constant(.noInput))
            .environmentObject(LocationSearchViewModel())
    }
}
