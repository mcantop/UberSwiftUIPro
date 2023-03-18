//
//  RideLoadingView.swift
//  UberSwiftUI
//
//  Created by Maciej on 17/03/2023.
//

import SwiftUI

struct RideLoadingView: View {
    @Environment(\.colorScheme) var scheme
    
    var body: some View {
        VStack {
            HStack {
                Text("Connecting you to a driver...")
                    .font(.headline)
                    .padding()
                
                Spacer()
                
                Spinner(lineWidth: 6, height: 64, width: 64)
                    .padding()
            }
        }
        .padding(.bottom, 36)
        .frame(maxWidth: .infinity)
        .background(
            scheme == .light ? .white : Color(.systemGray6)
        )
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct RideLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        RideLoadingView()
    }
}
