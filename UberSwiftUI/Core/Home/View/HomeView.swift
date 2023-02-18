//
//  HomeView.swift
//  UberSwiftUI
//
//  Created by Maciej on 17/02/2023.
//

import SwiftUI

struct HomeView: View {
    // MARK: - Properties
    @State private var showLocationSearchView = false
    
    // MARK: - Body
    var body: some View {
        ZStack(alignment: .top) {
            // MARK: - MapView
            UberMapViewRepresentable()
                .ignoresSafeArea()
            
            // MARK: - Header
            VStack(spacing: 0) {
                HStack(spacing: 8) {
                    MapViewActionButton(showLocationSearchView: $showLocationSearchView)
                    
                    if !showLocationSearchView {
                        LocationSearchActivationView(showLocationSearchView: $showLocationSearchView)
                    } else {
                        Spacer()
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background(showLocationSearchView ? .white : .white.opacity(0))
                
                if showLocationSearchView {
                    LocationSearchView()
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
