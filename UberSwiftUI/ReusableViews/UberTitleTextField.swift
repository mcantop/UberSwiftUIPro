//
//  UberTitleTextField.swift
//  UberSwiftUI
//
//  Created by Maciej on 20/02/2023.
//

import SwiftUI

struct UberTitleTextField: View {
    // MARK: - Properties
    let title: String
    let placeholder: String?
    var isSecure: Bool
    @Binding var text: String
    
    // MARK: - Init
    init(_ title: String, placeholder: String?, isSecure: Bool = false, text: Binding<String>) {
        self.title = title
        self.placeholder = placeholder
        self.isSecure = isSecure
        self._text = text
    }
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline)
            
            if isSecure {
                SecureField(placeholder ?? "", text: $text)
                    .font(.headline)
            } else {
                TextField(placeholder ?? "", text: $text)
                    .font(.headline)
            }
        }
    }
}

struct UberTitleTextField_Previews: PreviewProvider {
    static var previews: some View {
        UberTitleTextField(
            "Email Address",
            placeholder: "name@example.com",
            text: .constant("")
        )
    }
}
