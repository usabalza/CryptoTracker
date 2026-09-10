//
//  Coin.swift
//  CryptoTracker
//
//  Created by Uziel Sabalza on 5/6/26.
//

import Foundation

public struct Coin: Codable, Identifiable {
    public let id: String
    let name: String
    let symbol: String
    let image: String
    let rank: Int
    let percentChange24h: Double?
    let currentPrice: Double
    let marketCap: Double
    let volume: Double
    let ath: Double
    let athChange: Double
    let athDate: String
    let circulatingSupply: Double
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case symbol
        case image
        case rank = "market_cap_rank"
        case percentChange24h = "price_change_percentage_24h"
        case currentPrice = "current_price"
        case marketCap = "market_cap"
        case volume = "total_volume"
        case ath
        case athChange = "ath_change_percentage"
        case athDate = "ath_date"
        case circulatingSupply = "circulating_supply"
    }
}

extension Coin {
    static func createMock(id: String, name: String, symbol: String) -> Coin {
        return Coin(
            id: id,
            name: name,
            symbol: symbol,
            image: "https://fake.url",
            rank: 1,
            percentChange24h: 10.0,
            currentPrice: 5.0,
            marketCap: 5.0,
            volume: 3.0,
            ath: 2.0,
            athChange: 10.0,
            athDate: "2025-10-06T18:57:42.558Z",
            circulatingSupply: 50.0)
    }
}
