//
//  CryptoListViewModelTests.swift
//  CryptoTracker
//
//  Created by Uziel Sabalza on 4/9/26.
//

import Testing
import Foundation
@testable import CryptoTracker

@Suite("Pruebas del Listado de criptomonedas (ViewModel)")
struct CryptoListViewModelTests {
    // Test 1: Verificar escenario exitoso
    @Test("Al cargar la página con éxito, se deben añadir las criptomonedas al listado")
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
    @Test("Si la red falla en el fetch, la lista debe quedar vacía y capturar el mensaje de error")
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
    
    // 🔍 TEST 3: Búsqueda por Texto (Test Parametrizado)
    // El framework ejecutará esta función 3 veces, una por cada caso de la lista 'arguments'
    @Test("El buscador debe filtrar correctamente por coincidencia de nombre o id", arguments: [
        (searchText: "bit", expectedCount: 1, expectedFirstName: "bitcoin"),
        (searchText: "usdt", expectedCount: 1, expectedFirstName: "tether"),
        (searchText: "inexistente", expectedCount: 0, expectedFirstName: nil)
    ])
    @MainActor
    func searchFiltering(searchText: String, expectedCount: Int, expectedFirstName: String?) async {
        // Given
        let mockService = MockNetworkService()
        let sut = CryptoListViewModel(services: mockService)
        
        // Alimentamos el listado inicial
        sut.coins = [
            Coin.createMock(id: "bitcoin", name: "Bitcoin", symbol: "btc"),
            Coin.createMock(id: "tether", name: "Tether", symbol: "usdt")
        ]
        
        // When: Modificamos el texto de búsqueda
        sut.searchText = searchText
        
        // Then: Evaluamos la propiedad computada
        let result = sut.filteredCoin()
        
        #expect(result.count == expectedCount)
        if let expectedFirstName {
            #expect(result.first?.id == expectedFirstName)
        }
    }
    
    // Test 4: Verificar escenario exitoso
    @Test("Al recargar la página con éxito, se debe refrescar el listado de criptomonedas")
    @MainActor
    func refreshCoinAssetsSuccess() async {
        // Given (Dado que...) Inicializamos el Mock y el ViewModel localmente
        let mockNetworkService = MockNetworkService()
        let sut = CryptoListViewModel(services: mockNetworkService)
        
        let coin1 = Coin.createMock(id: "bitcoin", name: "Bitcoin", symbol: "btc")
        let coin2 = Coin.createMock(id: "ethereum", name: "Ethereum", symbol: "eth")
        let coin3 = Coin.createMock(id: "cardano", name: "Cardano", symbol: "ada")
        
        mockNetworkService.mockCoinList = [coin1, coin2, coin3]
        mockNetworkService.shouldReturnError = false
        
        // When (Cuando...) Ejecutamos la carga
        await sut.refreshCoinAssets()
        
        // Then (Entonces...) Validamos usando las nuevas macros #expect
        #expect(sut.coins.count == 3)
        #expect(sut.coins.first?.symbol == "btc")
        #expect(sut.errorMessage == nil)
        #expect(sut.isLoading == false)
    }
    
    // Test 5: Verificar escenario de error de red
    @Test("Si la red falla en el refresh, la lista debe quedar vacía y capturar el mensaje de error")
    @MainActor
    func refreshCoinAssetsFailure() async {
        // Given
        let mockNetworkService = MockNetworkService()
        let sut = CryptoListViewModel(services: mockNetworkService)
        mockNetworkService.shouldReturnError = true
        
        // When
        await sut.refreshCoinAssets()
        
        // Then
        #expect(sut.coins.isEmpty)
        #expect(sut.errorMessage != nil) // Evaluamos que contenga un string de error
        #expect(sut.isLoading == false)
    }
}
