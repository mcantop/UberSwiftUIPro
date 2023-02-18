//
//  LocationSearchView.swift
//  UberSwiftUI
//
//  Created by Maciej on 17/02/2023.
//

import SwiftUI

struct LocationSearchView: View {
    // MARK: - Properties
    @Binding var showLocationSearchView: Bool
    @Environment(\.colorScheme) var scheme
    @EnvironmentObject var locationViewModel: LocationSearchViewModel
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Header
            ZStack {
                Rectangle()
                    .fill(.white)
                    .frame(height: 102)
                    .shadow(color: .black.opacity(0.12), radius: 5, y: 10)
                
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
                                .background(.gray.opacity(0.15))
                                .clipShape(Capsule())
                                .frame(maxHeight: .infinity)
                            
                            TextField("Where to?", text: $locationViewModel.queryFragment)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(.gray.opacity(0.25))
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
            ScrollView(showsIndicators: false) {
                VStack {
                    ForEach(locationViewModel.results, id: \.self) { result in
                        LocationSearchResultCell(name: result.title, address: result.subtitle)
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.25)) {
                                    locationViewModel.selectLocation(result.title)
                                    showLocationSearchView.toggle()
                                }
                            }
                    }
                }
            }
        }
        .background(scheme == .light ? .white : .black)
    }
}

struct LocationSearchView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchView(showLocationSearchView: .constant(false))
            .environmentObject(LocationSearchViewModel())
    }
}
