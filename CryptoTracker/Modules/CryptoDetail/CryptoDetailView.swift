//
//  CryptoDetailView.swift
//  CryptoTracker
//
//  Created by Uziel Sabalza on 5/6/26.
//

import SwiftUI
import SwiftData
import Charts

struct CryptoDetailView: View {
    
    @EnvironmentObject var router: Router
    @StateObject var viewModel: CryptoDetailViewModel
    @Query private var allTransactions: [CoinTransaction]
    
    init(selected: Coin) {
        self._viewModel = StateObject(wrappedValue: CryptoDetailViewModel(selectedCoin: selected))
    }
    
    private var chartColor: Color {
        guard let first = viewModel.priceHistory.first?.price,
              let last = viewModel.priceHistory.last?.price else { return .blue }
        return last >= first ? .green : .red
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        AsyncImage(url: URL(string: viewModel.selectedCoin.image)) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 50, height: 50)
                        Text(viewModel.selectedCoin.name)
                            .font(.largeTitle)
                            .bold()
                        Text("# \(viewModel.selectedCoin.rank)")
                            .font(.largeTitle)
                            .bold()
                            .foregroundStyle(.gray)
                        
                    }
                }
                .padding(.horizontal)
                
                PickerView(selectedRange: $viewModel.selectedRange)
                    .onChange(of: viewModel.selectedRange) { _, _ in
                        Task {
                            await viewModel.loadChartData()
                            withAnimation(.easeInOut(duration: 0.4)) {}
                        }
                    }
                
                ChartView(priceHistory: viewModel.priceHistory, isLoading: viewModel.isLoading, chartColor: chartColor)
                
                Divider()
                
                let summary = viewModel.calculateHoldingsSummary(for: allTransactions)
                if summary.hasHoldings {
                    SummaryView(summary: summary, coinSymbol: viewModel.selectedCoin.symbol)
                    
                }
                
                Divider()
                
                MarketGridView(coin: viewModel.selectedCoin)
                
                Divider()
                
                ConverterView(coinName: viewModel.selectedCoin.name, coinSymbol: viewModel.selectedCoin.symbol, cryptoAmount: $viewModel.cryptoAmountString, usdAmount: $viewModel.usdAmountString) {
                    viewModel.convertCryptoToUSD()
                } onUSDChanged: {
                    viewModel.convertUSDToCrypto()
                }
                
                Divider()
                
                MyHoldingsView(chartColor: chartColor) {
                    router.push(to: .cryptoTransactions(viewModel.selectedCoin.id, viewModel.selectedCoin.name))
                } addTransaction: {
                    router.presentSheet(.addTransaction(viewModel.selectedCoin))
                }
                
            }
        }
        
        .task {
            await viewModel.loadChartData()
        }
    }
}
