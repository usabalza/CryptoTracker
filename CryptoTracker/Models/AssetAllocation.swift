//
//  AssetAllocation.swift
//  CryptoTracker
//
//  Created by Uziel Sabalza on 3/9/26.
//

import SwiftUI

struct AssetAllocation: Identifiable {
    let id = UUID()
    let coinId: String
    let name: String
    let symbol: String
    let totalTokens: Double
    let totalValueUSD: Double
    let percentage: Double
}
