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
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var homeViewModel: HomeViewModel
    @State private var mapState: MapState = .noInput
    @State private var showingSheet = false
    @State private var showingSideMenu = false
    @State private var settingsDetent = PresentationDetent.medium
    
    // TODO: Refactor bindings if possible
    // They set value to showingSheet which really does nothing
    private var showingRideRequestBinding: Binding<Bool> {
        Binding(get: {
            (self.mapState == .locationSelected || self.mapState == .polylineAdded) &&
            self.authViewModel.currentUser?.accountType == .passenger
        }) { _ in
            self.showingSheet = true
        }
    }
    private var showingRideAcceptBinding: Binding<Bool> {
        Binding(get: {
            self.homeViewModel.trip != nil &&
            self.authViewModel.currentUser?.accountType == .driver &&
            self.mapState == .tripRequested
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
                    
                    BottomRideStateView(user: user, mapState: mapState)
                        .edgesIgnoringSafeArea(.bottom)
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
                homeViewModel.userLocation = location
            }
        }
        .onReceive(homeViewModel.$selectedUberLocation) { location in
            if location != nil {
                self.mapState = .locationSelected
            }
        }
        .onReceive(homeViewModel.$trip) { trip in
            guard let trip = trip else {
                self.mapState = .noInput
                return
            }
            
            withAnimation(.spring()) {
                switch trip.state {
                case .requested:
                    self.mapState = .tripRequested
                case .rejected:
                    self.mapState = .tripRejected
                case .accepted:
                    self.mapState = .tripAccepted
                case .passengerCancelled:
                    self.mapState = .tripCancelledByPassenger
                case .driverCancelled:
                    self.mapState = .tripCancelledByDriver
                }
            }
        }
        // MARK: - Ride Request Sheet
        .sheet(isPresented: showingRideRequestBinding) {
            withAnimation(.easeInOut(duration: 0.25)) {
//                mapState = .noInput
//                homeViewModel.selectedUberLocation = nil
            }
        } content: {
            RideRequestView()
                .presentationDetents([.medium, .height(220)], selection: $settingsDetent)
                .presentationDragIndicator(.visible)
        }
        // MARK: - Ride Accept Sheet
        .sheet(isPresented: showingRideAcceptBinding) {
            print("DEBUG: Decline Ride here..")
        } content: {
            if let trip = homeViewModel.trip {
                RideAcceptView(trip: trip)
                    .presentationDetents([.height(600)])
                    .presentationDragIndicator(.visible)
            }
        }
    }
}

struct BottomRideStateView: View {
    // MARK: - Properties
    @EnvironmentObject var homeViewModel: HomeViewModel
    let user: User
    let mapState: MapState
    
    // MARK: - Body
    var body: some View {
        VStack {
            Spacer()
            
            homeViewModel.viewForState(mapState, user: user)
                .transition(.move(edge: .bottom))
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(HomeViewModel())
            .environmentObject(AuthViewModel())
    }
}
