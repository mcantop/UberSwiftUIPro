//
//  HomeView.swift
//  UberSwiftUI
//
//  Created by Maciej on 17/02/2023.
//

import SwiftUI

struct HomeView: View {
    // MARK: - Properties
    @Environment(\.colorScheme) var scheme
    @EnvironmentObject var locationViewModel: LocationSearchViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var mapState: MapState = .noInput
    @State private var showingSheet: Bool = false
    private var showingSheetBinding: Binding<Bool> {
        Binding(get: {
            self.mapState == .locationSelected || self.mapState == .polylineAdded
        }) { _ in
            self.showingSheet = true
        }
    }
    
    // MARK: - Body
    var body: some View {
        Group {
            if authViewModel.userSession == nil {
                LoginView()
            } else {
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
                        .background(
                            mapState == .searchingForLocation
                            ? scheme == .light ? .white : .black
                            : scheme == .light ? .white.opacity(0) : .black.opacity(0)
                        )
                        
                        if mapState == .searchingForLocation {
                            LocationSearchView(mapState: $mapState)
                        }
                    }
                }
                .onReceive(LocationManager.shared.$userLocation) { location in
                    if let location = location {
                        locationViewModel.userLocation = location
                    }
                }
                // MARK: - Bottom Sheet
                .sheet(isPresented: showingSheetBinding, onDismiss: {
                    mapState = .noInput
                    locationViewModel.selectedUberLocation = nil
                }) {
                    RideRequestView()
                        .presentationDetents([.height(440)])
                        .presentationDragIndicator(.visible)
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
