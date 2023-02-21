//
//  UberSocialOptionButton.swift
//  UberSwiftUI
//
//  Created by Maciej on 21/02/2023.
//

import SwiftUI

struct UberSocialOptionButton: View {
    // MARK: - Properties
    let type: SocialSignInType
    let action: () -> Void
    
    // MARK: - Body
    var body: some View {
        Button {
            action()
        } label: {
            Image(type.logo)
                .resizable()
                .renderingMode(.template)
                .foregroundColor(.primary)
                .frame(width: 44, height: 44)
        }
    }
}

struct UberSocialOptionButton_Previews: PreviewProvider {
    static var previews: some View {
        UberSocialOptionButton(type: .facebook) { }
    }
}
