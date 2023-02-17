//
//  MapViewActionButton.swift
//  UberSwiftUI
//
//  Created by Maciej on 17/02/2023.
//

import SwiftUI

struct MapViewActionButton: View {
    @Environment(\.colorScheme) var scheme
    @Binding var showLocationSearchView: Bool
    
    var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.25)) {
                showLocationSearchView.toggle()
            }
        } label: {
            Image(systemName: showLocationSearchView ? "arrow.left" : "line.3.horizontal")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .frame(width: 50, height: 50)
                .background(scheme == .light ? .white : .black)
                .capsuleOverlay()
                .clipShape(Circle())
        }
    }
}

struct MapViewActionButton_Previews: PreviewProvider {
    static var previews: some View {
        MapViewActionButton(showLocationSearchView: .constant(true))
    }
}
