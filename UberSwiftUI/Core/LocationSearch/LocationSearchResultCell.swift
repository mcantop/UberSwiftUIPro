//
//  LocationSearchResultCell.swift
//  UberSwiftUI
//
//  Created by Maciej on 17/02/2023.
//

import SwiftUI

struct LocationSearchResultCell: View {
    // MARK: - Properties
    @Environment(\.colorScheme) var scheme
    let name: String
    let address: String
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Spacer(minLength: 0).frame(height: 12)
            
            HStack(spacing: 12) {
                Image(systemName: "mappin.circle.fill")
                    .resizable()
                    .foregroundColor(scheme == .light ? .black.opacity(0.5) : .white.opacity(0.5))
                    .frame(width: 50, height: 50)
                
                VStack(alignment: .leading) {
                    // MARK: - Location Name
                    Text(name)
                        .fontWeight(.medium)
                    
                    Spacer(minLength: 0)
                    
                    // MARK: - Location Address
                    Text(address)
                        .fontWeight(.regular)
                        .foregroundColor(.gray)
                }
                .frame(height: 50)
                .lineLimit(1)
            }
            .padding(.horizontal, 12)
            
            Spacer(minLength: 0).frame(height: 12)
            
            Divider()
                .background(scheme == .light ? .black.opacity(0.5) : .white.opacity(0.5))
        }
    }
}

struct LocationSearchResultCell_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchResultCell(name: "Starbucks Coffee", address: "Warsaw")
    }
}
