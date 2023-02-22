//
//  SavedLocationViewModel.swift
//  UberSwiftUI
//
//  Created by Maciej on 21/02/2023.
//

import Foundation

enum FavoriteLocationViewModel: Int, CaseIterable, Identifiable {
    case home
    case work
    
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .work:
            return "Work"
        }
    }
    
    var imageName: String {
        switch self {
        case .home:
            return "house.circle.fill"
        case .work:
            return "archivebox.circle.fill"
        }
    }
    
    var id: Int {
        return rawValue
    }
}
