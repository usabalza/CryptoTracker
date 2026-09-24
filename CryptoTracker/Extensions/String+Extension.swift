//
//  String+Extension.swift
//  CryptoTracker
//
//  Created by Uziel Sabalza on 31/8/26.
//

import Foundation

extension String {
    func stringToDateISO8601() -> Date {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.date(from: self) ?? Date()
    }
}
