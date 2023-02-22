//
//  FavoriteLocationView.swift
//  UberSwiftUI
//
//  Created by Maciej on 21/02/2023.
//

import SwiftUI

struct FavoriteLocationRowView: View {
    // MARK: - Properties
    let viewModel: FavoriteLocationViewModel
    
    // MARK: - Init
    init(_ viewModel: FavoriteLocationViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: viewModel.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 30)
            
            VStack(alignment: .leading, spacing: 3) {
                Text(viewModel.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text("Add \(viewModel.title)")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
        }
        .frame(height: 35)
        .padding(.vertical, 2)
    }
}

struct FavoriteLocationView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteLocationRowView(.work)
    }
}
