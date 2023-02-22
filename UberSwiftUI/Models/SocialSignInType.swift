//
//  SocialSignInType.swift
//  UberSwiftUI
//
//  Created by Maciej on 21/02/2023.
//

import Foundation

enum SocialSignInType: Int, CaseIterable, Identifiable {
    case facebook
    case google
    
    var id: Int {
        return rawValue
    }
    
    var logo: String {
        switch self {
        case .facebook:
            return "facebook-logo"
        case .google:
            return "google-logo"
        }
    }
}
