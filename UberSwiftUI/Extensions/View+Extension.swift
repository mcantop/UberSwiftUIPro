//
//  View+Extension.swift
//  UberSwiftUI
//
//  Created by Maciej on 17/02/2023.
//

import SwiftUI

extension View {
    func capsuleOverlay() -> some View {
        return self.overlay(
            ZStack {
                Capsule()
                    .foregroundColor(.gray.opacity(0.15))
                
                Capsule()
                    .stroke(.gray.opacity(0.25), lineWidth: 2)
            }
        )
    }
}
