//
//  RideType.swift
//  UberSwiftUI
//
//  Created by Maciej on 19/02/2023.
//

import Foundation

enum RideType: Int, CaseIterable, Identifiable {
    case uberX
    case uberBlack
    case uberXL
    
    var id: Int {
        return rawValue
    }
    
    var description: String {
        switch self {
        case .uberX:
            return "UberX"
        case .uberBlack:
            return "UberBlack"
        case .uberXL:
            return "UberXL"
        }
    }
    
    var imageName: String {
        switch self {
        case .uberX:
            return "uber-x"
        case .uberBlack:
            return "uber-black"
        case .uberXL:
            return "uber-x"
        }
    }
    
    var baseFare: Double {
        switch self {
        case .uberX:
            return 5
        case .uberBlack:
            return 20
        case .uberXL:
            return 10
        }
    }
    
    func computePrice(distanceInMeters: Double) -> Double {
        let distanceInKilometers = distanceInMeters / 1000
        
        switch self {
        case .uberX:
            return distanceInKilometers * 1.5 + baseFare
        case .uberBlack:
            return distanceInKilometers * 2.0 + baseFare
        case .uberXL:
            return distanceInKilometers * 1.75 + baseFare
        }
    }
}
