//
//  SideMenuOptionViewModel.swift
//  UberSwiftUI
//
//  Created by Maciej on 21/02/2023.
//

import Foundation

enum SideMenuOptionViewModel: Int, CaseIterable, Identifiable {
    case payment
    case trips
    case help
    case settings
    
    var title: String {
        switch self {
        case .payment:
            return "Payment"
        case .trips:
            return "Your Trips"
        case .help:
            return "Help"
        case .settings:
            return "Settings"
        }
    }
    
    var imageName: String {
        switch self {
        case .payment:
            return "creditcard"
        case .trips:
            return "list.bullet.rectangle"
        case .help:
            return "questionmark.circle"
        case .settings:
            return "gearshape"
        }
    }
    
    var id: Int {
        return rawValue
    }
}
