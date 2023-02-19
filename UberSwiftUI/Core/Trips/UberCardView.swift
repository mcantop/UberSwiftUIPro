//
//  UberCardView.swift
//  UberSwiftUI
//
//  Created by Maciej on 19/02/2023.
//

import SwiftUI

struct UberCardView: View {
    // MARK: - Properties

    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            Image("uber-black")
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 6) {
                Text("Uber-X")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
                
                Text("$0.00")
                    .font(.subheadline)
                    .fontWeight(.thin)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 50)
            .padding(12)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.gray.opacity(0.3))
        .cornerRadius(12)
    }
}

struct UberCardView_Previews: PreviewProvider {
    static var previews: some View {
        UberCardView()
    }
}
