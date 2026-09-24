//
//  CoinPositionSummary.swift
//  CryptoTracker
//
//  Created by Uziel Sabalza on 3/9/26.
//

import Foundation

struct CoinPositionSummary {
    let totalTokens: Double
    let currentHoldingValue: Double
    let averageBuyPrice: Double
    let totalProfitLossUSD: Double
    let totalProfitLossPercentage: Double
    let hasHoldings: Bool
}
