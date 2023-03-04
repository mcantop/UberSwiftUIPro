//
//  User.swift
//  UberSwiftUI
//
//  Created by Maciej on 21/02/2023.
//

import Firebase

enum AccountType: Int, Codable {
    case passenger
    case driver
}

struct User: Codable {
    let fullname: String
    let email: String
    let uid: String
    
    var coordinates: GeoPoint
    var accountType: AccountType
    var homeLocation: FavoriteLocation?
    var workLocation: FavoriteLocation?
}
