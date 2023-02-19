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
    
    func newSheet<Content: View>(_ style: AnyShapeStyle, show: Binding<Bool>, onDismiss: @escaping() -> (), @ViewBuilder content: @escaping() -> Content) -> some View {
        self
            .sheet(isPresented: show, onDismiss: onDismiss) {
                content()
                    .background(RemoveBackgroundColor())
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background {
                        Rectangle()
                            .fill(style)
                            .ignoresSafeArea(.container, edges: .all)
                    }
            }
    }
}

// MARK: - Helper View
fileprivate struct RemoveBackgroundColor: UIViewRepresentable {
    func makeUIView(context: Context) -> some UIView {
        return UIView()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        DispatchQueue.main.async {
            uiView.superview?.superview?.backgroundColor = .clear
        }
    }
}
