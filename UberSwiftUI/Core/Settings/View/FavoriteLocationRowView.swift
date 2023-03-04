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
    let user: User
    
    // MARK: - Init
    init(_ viewModel: FavoriteLocationViewModel, user: User) {
        self.viewModel = viewModel
        self.user = user
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
                
                Text(viewModel.subtitle(user: user))
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
        FavoriteLocationRowView(.work, user: dev.mockUser)
    }
}
