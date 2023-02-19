//
//  HomeView.swift
//  UberSwiftUI
//
//  Created by Maciej on 17/02/2023.
//

import SwiftUI

struct HomeView: View {
    // MARK: - Properties
    @State private var mapState: MapState = .noInput
    
    // MARK: - Body
    var body: some View {
        ZStack(alignment: .top) {
            // MARK: - MapView
            UberMapViewRepresentable(mapState: $mapState)
                .ignoresSafeArea()
            
            // MARK: - Header
            VStack(spacing: 0) {
                HStack(spacing: 8) {
                    MapViewActionButton(mapState: $mapState)
                    
                    if mapState == .noInput {
                        LocationSearchActivationView(mapState: $mapState)
                    } else {
                        Spacer()
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background(mapState == .searchingForLocation ? .white : .white.opacity(0))
                
                if mapState == .searchingForLocation {
                    LocationSearchView(mapState: $mapState)
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(LocationSearchViewModel())
    }
}
