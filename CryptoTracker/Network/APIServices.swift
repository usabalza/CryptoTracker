//
//  APIServices.swift
//  CryptoTracker
//
//  Created by Uziel Sabalza on 5/6/26.
//

import Foundation

protocol ServiceProtocol {
    @MainActor func getCoins(limit: Int, offset: Int) async throws -> [Coin]
    @MainActor func getPricePointChart(coinId: String, range: TimeRange) async throws -> [PricePoint]
}

class APIServices: ServiceProtocol {
    var networkManager = NetworkManager()
    
    private static var chartCache: [String: (timestamp: Date, points: [PricePoint])] = [:]
    private static let cacheExpiration: TimeInterval = 300
    
    func getCoins(limit: Int = 20, offset: Int = 1) async throws -> [Coin] {
        return try await networkManager.request(endpoint: Endpoints.coins(limit: limit, offset: offset).urlString)
    }
    
    private func getMarketChart(coinId: String, range: String) async throws -> MarketChartResponse {
        return try await networkManager.request(endpoint: Endpoints.marketChart(coinId: coinId, days: range).urlString)
    }
    
    func getPricePointChart(coinId: String, range: TimeRange) async throws -> [PricePoint] {
        let cacheKey = "\(coinId)-\(range.rawValue)"
        
        if let cached = APIServices.chartCache[cacheKey], Date().timeIntervalSince(cached.timestamp) < APIServices.cacheExpiration {
            print("📦 Usando datos de la caché para \(cacheKey)")
            return cached.points
        } else {
            let chart = try await getMarketChart(coinId: coinId, range: range.daysValue)
            let pricePoints = chart.prices.compactMap { (point: [Double]) -> PricePoint? in
                guard point.count == 2 else { return nil }
                let timestampInSeconds = point[0] / 1000.0
                let price = point[1]
                return PricePoint(date: Date(timeIntervalSince1970: timestampInSeconds), price: price)
            }
            
            if !pricePoints.isEmpty {
                APIServices.chartCache[cacheKey] = (timestamp: Date(), points: pricePoints)
            }
            
            return pricePoints
        }
    }
}
