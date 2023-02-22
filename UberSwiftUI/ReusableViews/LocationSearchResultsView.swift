//
//  LocationSearchResultsView.swift
//  UberSwiftUI
//
//  Created by Maciej on 21/02/2023.
//

import SwiftUI

struct LocationSearchResultsView: View {
    // MARK: - Properties
    @StateObject var locationViewModel: LocationSearchViewModel
    let config: LocationResultsViewConfig
    
    // MARK: - Body
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                ForEach(locationViewModel.results, id: \.self) { result in
                    LocationSearchResultCell(name: result.title, address: result.subtitle)
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                locationViewModel.selectLocation(
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
            locationViewModel: LocationSearchViewModel(),
            config: .ride
        )
    }
}
