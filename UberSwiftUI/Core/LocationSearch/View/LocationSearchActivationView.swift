//
//  LocationSearchActivationView.swift
//  UberSwiftUI
//
//  Created by Maciej on 17/02/2023.
//

import SwiftUI

struct LocationSearchActivationView: View {
    @Environment(\.colorScheme) var scheme

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .fontWeight(.semibold)
            
            Text("Where to?")
                .fontWeight(.bold)
            
            Spacer()
        }
        .font(.title3)
        .padding(.horizontal, 16)
        .frame(height: 52)
        .background(scheme == .light ? .white : .black)
        .capsuleOverlay()
        .clipShape(Capsule())
    }
}

struct LocationSearchActivationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchActivationView()
    }
}
