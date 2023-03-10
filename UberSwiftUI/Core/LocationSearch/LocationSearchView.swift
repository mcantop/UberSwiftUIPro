//
//  LocationSearchView.swift
//  UberSwiftUI
//
//  Created by Maciej on 17/02/2023.
//

import SwiftUI

struct LocationSearchView: View {
    // MARK: - Properties
    @Environment(\.colorScheme) var scheme
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    private var backgroundColor: Color {
        return scheme == .light ? .white : .black
    }
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Header
            ZStack {
                // TODO: Refactor
                Rectangle()
                    .fill(scheme == .light ? .white : .black)
                    .frame(height: 102)
                    .shadow(
                        color: scheme == .light
                        ? .black.opacity(0.12)
                        : .white.opacity(0.12),
                        radius: 5, y: 10
                    )
                
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        Spacer(minLength: 0).frame(width: 12)
                        
                        VStack(alignment: .center, spacing: 5) {
                            Circle()
                                .fill(.blue)
                                .frame(width: 8, height: 8)
                            
                            RoundedRectangle(cornerRadius: 8)
                                .frame(width: 2, height: 25)
                            
                            RoundedRectangle(cornerRadius: 4)
                                .frame(width: 10, height: 10)
                        }
                        .frame(width: 50)
                        
                        Spacer(minLength: 0).frame(width: 12)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Current location")
                                .foregroundColor(.blue)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(.systemGray6))
                                .clipShape(Capsule())
                                .frame(maxHeight: .infinity)
                            
                            TextField("Where to?", text: $homeViewModel.queryFragment)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color(.systemGray5))
                                .clipShape(Capsule())
                                .frame(maxHeight: .infinity)
                        }
                        
                        Spacer(minLength: 0).frame(width: 12)
                    }
                    .frame(height: 80)
                    
                    Spacer(minLength: 0).frame(height: 12)
                }
            }
            
            // MARK: - ScrollView
            LocationSearchResultsView(
                homeViewModel: homeViewModel,
                config: .ride
            )
        }
        .background(backgroundColor)
    }
}

struct LocationSearchView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchView()
            .environmentObject(HomeViewModel())
    }
}
