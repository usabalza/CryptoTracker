//
//  MarketChart.swift
//  CryptoTracker
//
//  Created by Uziel Sabalza on 24/8/26.
//

import Foundation

struct MarketChartResponse: Codable {
    let prices: [[Double]]
}

struct PricePoint: Identifiable {
    let id = UUID()
    let date: Date
    let price: Double
}

extension PricePoint {
    static func createMock() -> PricePoint {
        return PricePoint(date: .init(), price: .random(in: 0...100))
    }
}
