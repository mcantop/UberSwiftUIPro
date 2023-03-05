//
//  LocationSearchResultsView.swift
//  UberSwiftUI
//
//  Created by Maciej on 21/02/2023.
//

import SwiftUI

struct LocationSearchResultsView: View {
    // MARK: - Properties
    @StateObject var homeViewModel: HomeViewModel
    let config: LocationResultsConfig
    
    // MARK: - Body
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                ForEach(homeViewModel.results, id: \.self) { result in
                    LocationSearchResultCell(name: result.title, address: result.subtitle)
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                homeViewModel.selectLocation(
                                    result,
                                    config: config
                                )
                            }
                        }
                }
            }
        }
    }
}

struct LocationSearchResultsView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchResultsView(
            homeViewModel: HomeViewModel(),
            config: .ride
        )
    }
}
