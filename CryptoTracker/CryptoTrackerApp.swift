//
//  CryptoTrackerApp.swift
//  CryptoTracker
//
//  Created by Uziel Sabalza on 5/6/26.
//

import SwiftUI
import SwiftData

@main
struct CryptoTrackerApp: App {
    @StateObject private var router = Router()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                let viewModel = CryptoListViewModel()
                CryptoListView(viewModel: viewModel)
                    .navigationDestination(for: Destination.self) { destination in
                        switch destination {
                        case .cryptoList:
                            EmptyView()
                        case .cryptoDetail(let selected):
                            CryptoDetailView(selected: selected)
                        case .cryptoTransactions(let coinId, let coinName):
                            TransactionsView(coinId: coinId, coinName: coinName)
                        case .globalChart(let coins):
                            GlobalChartView(coins: coins)
                        }
                    }
                    .sheet(item: $router.activeSheet) { sheet in
                        switch sheet {
                        case .addTransaction(let coin):
                            AddTransactionView(coinId: coin.id, coinName: coin.name, coinSymbol: coin.symbol, currentPrice: coin.currentPrice)
                                .presentationDetents([.medium, .large])
                        }
                    }
            }
            .environmentObject(router)
        }
        .modelContainer(for: CoinTransaction.self)
    }
}
