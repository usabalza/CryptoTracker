//
//  CryptoDetailViewModelTests.swift
//  CryptoTracker
//
//  Created by Uziel Sabalza on 4/9/26.
//

import Testing
import Foundation
@testable import CryptoTracker

@Suite("Pruebas del Detalle de criptomonedas (ViewModel)")
struct CryptoDetailViewModelTests {
    @Test("Al cargar la página con éxito, se debe calcular el sumario de los holdings por criptomoneda")
    @MainActor
    func calculateHoldingsForSummary() async {
        let mockNetworkService = MockNetworkService()
        let mockedCoin = Coin.createMock(id: "bitcoin", name: "Bitcoin", symbol: "btc")
        let sut = CryptoDetailViewModel(selectedCoin: mockedCoin, services: mockNetworkService)
        
        let mockedTransactions: [CoinTransaction] = [
            CoinTransaction.createMock(id: "bitcoin", name: "Bitcoin", symbol: "btc"),
            CoinTransaction.createMock(id: "ethereum", name: "Ethereum", symbol: "eth"),
            CoinTransaction.createMock(id: "cardano", name: "Cardano", symbol: "ada")
        ]
        
        let summary = sut.calculateHoldingsSummary(for: mockedTransactions)
        
        #expect(summary.hasHoldings == true)
    }
    
    @Test("La conversión de Crypto a USD debe realizarse correctamente")
    @MainActor
    func convertCryptoToUSD() {
        let mockNetworkService = MockNetworkService()
        let mockedCoin = Coin.createMock(id: "bitcoin", name: "Bitcoin", symbol: "btc")
        let sut = CryptoDetailViewModel(selectedCoin: mockedCoin, services: mockNetworkService)
        sut.cryptoAmountString = "50"
        sut.priceHistory = [
            PricePoint.createMock()
        ]
        
        sut.convertCryptoToUSD()
        
        #expect(sut.usdAmountString.isEmpty == false)
        #expect(Double(sut.usdAmountString) ?? 0.0 > 0)
    }
    
    @Test("La conversión de USD a Crypto debe realizarse correctamente")
    @MainActor
    func convertUSDToCrypto() {
        let mockNetworkService = MockNetworkService()
        let mockedCoin = Coin.createMock(id: "bitcoin", name: "Bitcoin", symbol: "btc")
        let sut = CryptoDetailViewModel(selectedCoin: mockedCoin, services: mockNetworkService)
        sut.usdAmountString = "50"
        sut.priceHistory = [
            PricePoint.createMock()
        ]
        
        sut.convertUSDToCrypto()
        
        #expect(sut.cryptoAmountString.isEmpty == false)
        #expect(Double(sut.cryptoAmountString) ?? 0.0 > 0)
    }
    
    @Test("Al cargar la página con éxito, se debe cargar la data del gráfico")
    @MainActor
    func fetchCoinAssetsSuccess() async {
        // Given (Dado que...) Inicializamos el Mock y el ViewModel localmente
        let mockNetworkService = MockNetworkService()
        let sut = CryptoListViewModel(services: mockNetworkService)
        
        let coin1 = Coin.createMock(id: "bitcoin", name: "Bitcoin", symbol: "btc")
        let coin2 = Coin.createMock(id: "ethereum", name: "Ethereum", symbol: "eth")
        let coin3 = Coin.createMock(id: "cardano", name: "Cardano", symbol: "ada")
        
        mockNetworkService.mockCoinList = [coin1, coin2, coin3]
        mockNetworkService.shouldReturnError = false
        
        // When (Cuando...) Ejecutamos la carga
        await sut.fetchCoinAssets()
        
        // Then (Entonces...) Validamos usando las nuevas macros #expect
        #expect(sut.coins.count == 3)
        #expect(sut.coins.first?.symbol == "btc")
        #expect(sut.errorMessage == nil)
        #expect(sut.isLoading == false)
    }
    
    // Test 2: Verificar escenario de error de red
    @Test("Si la red falla, el gráfico no debe mostrarse y capturar el mensaje de error")
    @MainActor
    func fetchCoinAssetsFailure() async {
        // Given
        let mockNetworkService = MockNetworkService()
        let sut = CryptoListViewModel(services: mockNetworkService)
        mockNetworkService.shouldReturnError = true
        
        // When
        await sut.fetchCoinAssets()
        
        // Then
        #expect(sut.coins.isEmpty)
        #expect(sut.errorMessage != nil) // Evaluamos que contenga un string de error
        #expect(sut.isLoading == false)
    }
}
