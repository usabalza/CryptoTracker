//
//  MockNetworkService.swift
//  CryptoTracker
//
//  Created by Uziel Sabalza on 4/9/26.
//

import SwiftUI
@testable import CryptoTracker

class MockNetworkService: ServiceProtocol {
    var shouldReturnError = false
    var mockCoinList: [Coin] = []
    var mockPricePoint: [PricePoint] = []
                         
    func getCoins(limit: Int, offset: Int) async throws -> [Coin] {
        if shouldReturnError {
            throw URLError(.notConnectedToInternet)
        }
        return mockCoinList
    }
    
    func getPricePointChart(coinId: String, range: TimeRange) async throws -> [PricePoint] {
        if shouldReturnError {
            throw URLError(.notConnectedToInternet)
        }
        return mockPricePoint
    }
    
    
}
