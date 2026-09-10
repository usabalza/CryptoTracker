//
//  Double+Extension.swift
//  CryptoTracker
//
//  Created by Uziel Sabalza on 5/6/26.
//

import Foundation
import SwiftUI

extension Double {
    func toCurrency(code: String = "USD") -> String {
        return self.formatted(.currency(code: code))
    }
    
    func toCompactCurrency(code: String = "USD") -> String {
        return self.formatted(.currency(code: code).notation(.compactName))
    }
    
    func toCompactNumber() -> String {
        return self.formatted(.number.notation(.compactName))
    }
    
}

extension Optional where Wrapped == Double {
    var asPercentString: String {
        guard let value = self else {
            return "---"
        }
        
        return String(format: "%.2f%%", value)
    }
}
