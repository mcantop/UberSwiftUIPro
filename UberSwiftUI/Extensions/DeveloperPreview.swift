//
//  DeveloperPreview.swift
//  UberSwiftUI
//
//  Created by Maciej on 25/02/2023.
//

import SwiftUI
import Firebase

extension PreviewProvider {
    static var dev: DeveloperPrevier {
        return DeveloperPrevier.shared
    }
}

final class DeveloperPrevier {
    static let shared = DeveloperPrevier()
    
    let mockUser = User(
        fullname: "Future",
        email: "future@mail.com",
        uid: NSUUID().uuidString,
        coordinates: GeoPoint(latitude: 37.38, longitude: -122.05),
        accountType: .passenger
    )
}
