//
//  BottomSignTextType.swift
//  UberSwiftUI
//
//  Created by Maciej on 21/02/2023.
//

import Foundation

enum BottomSignTextType {
    case signIn
    case signUp
    
    var text: String {
        switch self {
        case .signIn:
            return "Don't have an account? SIGN UP"
        case .signUp:
            return "Already have an account? SIGN IN"
        }
    }
}
