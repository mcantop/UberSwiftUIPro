//
//  UberBottomSignText.swift
//  UberSwiftUI
//
//  Created by Maciej on 21/02/2023.
//

import SwiftUI

struct UberBottomSignText: View {
    // MARK: - Properties
    let type: BottomSignTextType
    
    // MARK: - Body
    var body: some View {
        Text(type.text)
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundColor(.primary)
    }
}

struct UberBottomSignText_Previews: PreviewProvider {
    static var previews: some View {
        UberBottomSignText(type: .signIn)
    }
}
