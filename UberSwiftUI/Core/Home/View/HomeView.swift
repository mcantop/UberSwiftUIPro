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
    @EnvironmentObject var homeViewModel: HomeViewModel
    @State private var mapState: MapState = .noInput
    @State private var showingSheet = false
    @State private var showingSideMenu = false
    @State private var settingsDetent = PresentationDetent.medium
    
    // TODO: Refactor
    private var showingSheetBinding: Binding<Bool> {
        Binding(get: {
            self.mapState == .locationSelected || self.mapState == .polylineAdded
        }) { _ in
            self.showingSheet = true
        }
    }
    private var screenWidth: CGFloat {
        return UIScreen.main.bounds.width - 60
    }
    
    // MARK: - Body
    var body: some View {
        if authViewModel.userSession == nil {
            LoginView()
        } else if let user = authViewModel.currentUser {
            NavigationStack {
                ZStack {
                    if showingSideMenu {
                        SideMenuView(user: user)
                    }
                    
                    mapView
                        .offset(x: showingSideMenu ? screenWidth : 0)
                        .onTapGesture {
                            if showingSideMenu {
                                withAnimation(.easeInOut(duration: 0.25)) {
                                    showingSideMenu.toggle()
                                }
                            }
                        }
                }
                .onAppear {
                    /// If we want to hide the SideMenu after exiting NavigationLink.
                     showingSideMenu = false
                }
            }
        }
    }
}

extension HomeView {
    var mapView: some View {
        ZStack(alignment: .top) {
            // MARK: - MapView
            ZStack {
                UberMapViewRepresentable(mapState: $mapState)
                if showingSideMenu {
                    Color.black.opacity(0.3)
                }
            }
            .ignoresSafeArea()
            
            // MARK: - Header
            VStack(spacing: 0) {
                HStack(spacing: 8) {
                    MapViewActionButton(
                        mapState: $mapState,
                        showingSideMenu: $showingSideMenu
                    )
                    
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
                    LocationSearchView()
                }
            }
            .opacity(showingSideMenu ? 0 : 1)
        }
        .onReceive(LocationManager.shared.$userLocation) { location in
            if let location = location {
                locationViewModel.userLocation = location
            }
        }
        .onReceive(locationViewModel.$selectedUberLocation) { location in
            if location != nil {
                self.mapState = .locationSelected
            }
        }
        // MARK: - Bottom Sheet
        .sheet(isPresented: showingSheetBinding, onDismiss: {
            withAnimation(.easeInOut(duration: 0.25)) {
                mapState = .noInput
                locationViewModel.selectedUberLocation = nil
            }
        }) {
            RideRequestView()
                .presentationDetents([.medium, .height(220)], selection: $settingsDetent)
                .presentationDragIndicator(.visible)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(LocationSearchViewModel())
            .environmentObject(AuthViewModel())
    }
}
