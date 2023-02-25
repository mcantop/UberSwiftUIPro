//
//  FavoriteLocation.swift
//  UberSwiftUI
//
//  Created by Maciej on 23/02/2023.
//

import Foundation
import Firebase

struct FavoriteLocation: Codable {
    let title: String
    let address: String
    let coordinates: GeoPoint
}
