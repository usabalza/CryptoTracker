//
//  Date+Extension.swift
//  CryptoTracker
//
//  Created by Uziel Sabalza on 31/8/26.
//

import Foundation

extension Date {
    public func dateToShortDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        return dateFormatter.string(from: self)
    }
}

