//
//  CryptoDetailViewModel.swift
//  CryptoTracker
//
//  Created by Uziel Sabalza on 5/6/26.
//

import SwiftUI
import Combine

class CryptoDetailViewModel: ObservableObject {
    let services: ServiceProtocol
    let selectedCoin: Coin
    
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    @Published var priceHistory: [PricePoint] = []
    @Published var selectedRange: TimeRange = .sevenDays
    @Published var cryptoAmountString: String = "1"
    @Published var usdAmountString: String = ""
    
    init(selectedCoin: Coin, services: ServiceProtocol = APIServices()) {
        self.selectedCoin = selectedCoin
        self.services = services
    }
    
    /// Obtiene el precio actual directo del detalle de mercado de CoinGecko
    private var currentPrice: Double {
        return priceHistory.last?.price ?? 0.0
    }
    
    func calculateHoldingsSummary(for transactions: [CoinTransaction]) -> CoinPositionSummary {
        // Filtrar transacciones exclusivas de esta moneda
        let tokenTransactions = transactions.filter { $0.coinId == selectedCoin.id }
        
        guard !tokenTransactions.isEmpty else {
            return CoinPositionSummary(totalTokens: 0, currentHoldingValue: 0, averageBuyPrice: 0, totalProfitLossUSD: 0, totalProfitLossPercentage: 0, hasHoldings: false)
        }
        
        var totalTokens = 0.0
        var totalSpentNet = 0.0 // Dinero real invertido neto
        
        // Calcular el balance de tokens según compras y ventas
        for tx in tokenTransactions {
            if tx.type == .buy {
                totalTokens += tx.amount
                totalSpentNet += (tx.amount * tx.pricePerCoin)
            } else if tx.type == .sell {
                // Restamos tokens y ajustamos proporcionalmente
                totalTokens -= tx.amount
                totalSpentNet -= (tx.amount * tx.pricePerCoin)
            }
        }
        
        // Evitar valores negativos si el usuario registra inconsistencias
        if totalTokens < 0 { totalTokens = 0 }
        
        let priceToday = selectedCoin.currentPrice
        let currentHoldingValue = totalTokens * priceToday
        
        // Calcular precio promedio de compra
        let totalBuyTokens = tokenTransactions.filter { $0.type == .buy }.reduce(0.0) { $0 + $1.amount }
        let totalBuySpent = tokenTransactions.filter { $0.type == .buy }.reduce(0.0) { $0 + ($1.amount * $1.pricePerCoin) }
        let averageBuyPrice = totalBuyTokens > 0 ? (totalBuySpent / totalBuyTokens) : 0.0
        
        // Ganancias o pérdidas netas
        let totalProfitLossUSD = currentHoldingValue - totalSpentNet
        let totalProfitLossPercentage = totalSpentNet > 0 ? (totalProfitLossUSD / totalSpentNet) * 100 : 0.0
        
        return CoinPositionSummary(
            totalTokens: totalTokens,
            currentHoldingValue: currentHoldingValue,
            averageBuyPrice: averageBuyPrice,
            totalProfitLossUSD: totalProfitLossUSD,
            totalProfitLossPercentage: totalProfitLossPercentage,
            hasHoldings: totalTokens > 0
        )
    }
    
    func convertCryptoToUSD() {
        guard let cryptoAmount = Double(cryptoAmountString), currentPrice > 0 else {
            usdAmountString = ""
            return
        }
        let calculatedUSD = cryptoAmount * currentPrice
        // Formateamos con dos decimales para el campo de texto
        usdAmountString = String(format: "%.2f", calculatedUSD)
    }
    
    func convertUSDToCrypto() {
        guard let usdAmount = Double(usdAmountString), currentPrice > 0 else {
            cryptoAmountString = ""
            return
        }
        let calculatedCrypto = usdAmount / currentPrice
        // Formateamos con hasta 6 decimales para soportar fracciones pequeñas de cripto
        cryptoAmountString = String(format: "%.6f", calculatedCrypto)
    }
    
    func loadChartData() async {
        isLoading = true
        do {
            self.priceHistory = try await services.getPricePointChart(coinId: selectedCoin.id, range: selectedRange)
        } catch {
            self.errorMessage = "Error al cargar el grafico: \(error.localizedDescription)"
        }
        isLoading = false
    }
    
}
