//
//  GlobalChartViewModel.swift
//  CryptoTracker
//
//  Created by Uziel Sabalza on 3/9/26.
//

import SwiftUI
import SwiftData
import Combine

class GlobalChartViewModel: ObservableObject {
    let coins: [Coin]
    
    @Published var isLoading: Bool = false
    @Published var allocations: [AssetAllocation] = []
    @Published var totalValue: Double = 0.0
    
    init(coins: [Coin]) {
        self.coins = coins
    }
    
    func refreshGlobalChart(transactions: [CoinTransaction]) async {
        guard !transactions.isEmpty else {
            self.allocations = []
            self.totalValue = 0.0
            return
        }
        
        isLoading = true
        
        // 3. Calcular la cantidad de tokens netos que posee por cada moneda
        var tokenBalances: [String: Double] = [:]
        for tx in transactions {
            let currentBalance = tokenBalances[tx.coinId] ?? 0.0
            if tx.type == .buy {
                tokenBalances[tx.coinId] = currentBalance + tx.amount
            } else {
                tokenBalances[tx.coinId] = max(0.0, currentBalance - tx.amount)
            }
        }
        
        // 4. Calcular el valor en USD de cada activo y el total global
        var tempAllocations: [AssetAllocation] = []
        var globalTotal = 0.0
        
        for coin in coins {
            let tokens = tokenBalances[coin.id] ?? 0.0
            guard tokens > 0 else { continue } // Ignorar monedas que ya vendió por completo
            
            let priceToday = coin.currentPrice
            let valueUSD = tokens * priceToday
            
            globalTotal += valueUSD
            
            tempAllocations.append(
                AssetAllocation(
                    coinId: coin.id,
                    name: coin.name,
                    symbol: coin.symbol,
                    totalTokens: tokens,
                    totalValueUSD: valueUSD,
                    percentage: 0.0 // Se calcula abajo
                )
            )
        }
        
        self.totalValue = globalTotal
        
        // 5. Asignar los porcentajes reales de distribución
        self.allocations = tempAllocations.map { asset in
            let pct = globalTotal > 0 ? (asset.totalValueUSD / globalTotal) * 100 : 0.0
            return AssetAllocation(
                coinId: asset.coinId,
                name: asset.name,
                symbol: asset.symbol,
                totalTokens: asset.totalTokens,
                totalValueUSD: asset.totalValueUSD,
                percentage: pct
            )
        }.sorted(by: { $0.totalValueUSD > $1.totalValueUSD }) // Ordenar de mayor a menor valor
        
        isLoading = false
    }
}
