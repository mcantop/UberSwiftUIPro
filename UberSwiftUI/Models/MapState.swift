//
//  MapState.swift
//  UberSwiftUI
//
//  Created by Maciej on 18/02/2023.
//

import Foundation

enum MapState {
    case noInput
    case searchingForLocation
    case locationSelected
    case polylineAdded
    case tripRequested
    case tripRejected
    case tripAccepted
}
