//
//  FavoriteLocationSearchView.swift
//  UberSwiftUI
//
//  Created by Maciej on 21/02/2023.
//

import SwiftUI

struct FavoriteLocationSearchView: View {
    // MARK: - Properties
    @Environment(\.colorScheme) var scheme
    @State private var text = ""
    @StateObject var homeViewModel = HomeViewModel()
    let config: FavoriteLocationViewModel
    
    // MARK: - Body
    var body: some View {
        VStack {
            ZStack {
                // TODO: Refactor
                Rectangle()
                    .fill(scheme == .light ? .white : .black)
                    .frame(height: 51)
                    .shadow(
                        color: scheme == .light
                        ? .black.opacity(0.12)
                        : .white.opacity(0.12),
                        radius: 5, y: 10
                    )
                
                TextField("Search for a location..", text: $homeViewModel.queryFragment)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color(.systemGray5))
                    .clipShape(Capsule())
                    .padding(.horizontal)
            }
            
            Spacer()
            
            LocationSearchResultsView(
                homeViewModel: homeViewModel,
                config: .saveLocation(config)
            )
        }
    }
}

struct FavoriteLocationSearchView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            FavoriteLocationSearchView(config: .work)
        }
    }
}
