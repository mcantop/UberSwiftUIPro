//
//  UberWideButton.swift
//  UberSwiftUI
//
//  Created by Maciej on 21/02/2023.
//

import SwiftUI

struct UberWideButton: View {
    // MARK: - Properties
    let text: String
    let imageName: String?
    let buttonTextColor: Color
    let buttonBackgroundColor: Color
    let action: () -> Void
    
    // MARK: - Init
    init(_ text: String, imageName: String? = nil, buttonTextColor: Color, buttonBackgroundColor: Color, action: @escaping () -> Void) {
        self.text = text
        self.imageName = imageName
        self.buttonTextColor = buttonTextColor
        self.buttonBackgroundColor = buttonBackgroundColor
        self.action = action
    }
    
    // MARK: - Body
    var body: some View {
        Button {
            action()
        } label: {
            HStack(spacing: 4) {
                Text(text)

                if let imageName = imageName {
                    Image(systemName: imageName)
                }
            }
            .font(.title3)
            .fontWeight(.semibold)
            .foregroundColor(buttonTextColor)
            .frame(maxWidth: .infinity)
            .padding()
            .background(buttonBackgroundColor)
            .cornerRadius(20)
        }
    }
}

struct UberWideButton_Previews: PreviewProvider {
    static var previews: some View {
        UberWideButton("Sign In", imageName: "", buttonTextColor: .white, buttonBackgroundColor: .black) { }
    }
}
