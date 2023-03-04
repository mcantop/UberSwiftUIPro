//
//  SettingsRowView.swift
//  UberSwiftUI
//
//  Created by Maciej on 21/02/2023.
//

import SwiftUI

struct SettingsRowView: View {
    // MARK: - Properties
    let name: String
    let imageName: String
    
    // MARK: - Body
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 30)
            
            Text(name)
                .font(.subheadline)
                .fontWeight(.medium)
        }
        .foregroundColor(.primary)
        .frame(height: 35)
        .padding(.vertical, 2)
    }
}

struct SettingsRowView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsRowView(
            name: "Sign Out",
            imageName: "arrow.left.circle.fill"
        )
    }
}
