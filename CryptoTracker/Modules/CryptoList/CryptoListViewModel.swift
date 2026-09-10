//
//  CryptoListViewModel.swift
//  CryptoTracker
//
//  Created by Uziel Sabalza on 5/6/26.
//

import SwiftUI
import Combine

class CryptoListViewModel: ObservableObject {
    
    let services: ServiceProtocol
    
    @Published var coins: [Coin] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    @Published var searchText = ""
    
    private var currentOffset = 1
    private let limit = 20
    
    init(services: ServiceProtocol = APIServices()) {
        self.services = services
    }
    
    func filteredCoin() -> [Coin] {
        // var baseList = coins
        if searchText.isEmpty {
            return coins
        } else {
            return coins.filter { coin in
                coin.name.localizedCaseInsensitiveContains(searchText) ||
                coin.symbol.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    func fetchCoinAssets() async {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let newCoins = try await services.getCoins(
                limit: limit,
                offset: currentOffset
            )
            coins.append(contentsOf: newCoins)
            self.currentOffset += limit
        } catch {
            self.errorMessage = "Error al cargar los datos: \(error.localizedDescription)"
        }
        isLoading = false
    }
    
    func refreshCoinAssets() async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        
        do {
            let freshCoins = try await services.getCoins(
                limit: limit,
                offset: 1
            )
            self.currentOffset = limit
            self.coins = freshCoins
            
        } catch {
            self.errorMessage = "Error al refrescar: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
}
