//
//  TimeRange.swift
//  CryptoTracker
//
//  Created by Uziel Sabalza on 2/9/26.
//

enum TimeRange: String, CaseIterable, Identifiable {
    case oneDay = "1 día"
    case sevenDays = "7 días"
    case thirtyDays = "30 días"
    
    var id: String { self.rawValue }
    
    // Días exactos requeridos por el parámetro de CoinGecko
    var daysValue: String {
        switch self {
        case .oneDay: return "1"
        case .sevenDays: return "7"
        case .thirtyDays: return "30"
        }
    }
}
