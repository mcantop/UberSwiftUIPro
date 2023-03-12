//
//  Double+Extension.swift
//  UberSwiftUI
//
//  Created by Maciej on 20/02/2023.
//

import Foundation

// MARK: - Public Helpers
extension Double {
    func toCurrency() -> String {
        return currencyFormatter.string(for: self) ?? ""
    }
    
    func distanceInKilometeresString() -> String {
        return distanceFormatter.string(for: self / 1000) ?? ""
    }
}

// MARK: - Private Helpers
private extension Double {
    var currencyFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    var distanceFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 1
        return formatter
    }
}
