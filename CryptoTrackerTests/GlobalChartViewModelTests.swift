//
//  GlobalChartViewModelTests.swift
//  CryptoTracker
//
//  Created by Uziel Sabalza on 8/9/26.
//

import Testing
import Foundation
@testable import CryptoTracker

@Suite("Pruebas del gráfico global de balance (ViewModel)")
struct GlobalChartViewModelTests {
    
    @Test("Al refrescar el gráfico global, se debe mostrar el porcentaje de cada criptomoneda guardada")
    @MainActor
    func refreshGlobalChart() async {
        // Given (Dado que...) Inicializamos el Mock y el ViewModel localmente
        let mockCoinList: [Coin] = [
            Coin.createMock(id: "bitcoin", name: "Bitcoin", symbol: "btc"),
            Coin.createMock(id: "ethereum", name: "Ethereum", symbol: "eth"),
            Coin.createMock(id: "solana", name: "Solana", symbol: "sol")
        ]
        
        let mockTransactionList: [CoinTransaction] = [
            CoinTransaction.createMock(id: "bitcoin", name: "Bitcoin", symbol: "btc"),
            CoinTransaction.createMock(id: "ethereum", name: "Ethereum", symbol: "eth"),
            CoinTransaction.createMock(id: "solana", name: "Solana", symbol: "sol")
        ]
        
        let sut = GlobalChartViewModel(coins: mockCoinList)
        
        await sut.refreshGlobalChart(transactions: mockTransactionList)
        
        #expect(sut.allocations.count == 3)
        #expect(sut.totalValue > 0)
        #expect(sut.isLoading == false)
    }
}
