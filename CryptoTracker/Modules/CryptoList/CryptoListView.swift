//
//  CryptoListView.swift
//  CryptoTracker
//
//  Created by Uziel Sabalza on 5/6/26.
//

import SwiftUI

struct CryptoListView: View {
    @EnvironmentObject var router: Router
    @StateObject var viewModel: CryptoListViewModel
    
    private let initialPlaceholders = (0..<6).map { _ in UUID() }
    private let paginationPlaceholders = (0..<2).map { _ in UUID() }
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack(spacing: 12) {
                    coinListContent
                }
            }
        }
        .navigationTitle("CryptoTracker")
        .searchable(text: $viewModel.searchText,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: "Buscar criptomonedas..."
        )
        .refreshable {
            await viewModel.refreshCoinAssets()
            
        }
        .task {
            if viewModel.coins.isEmpty {
                await viewModel.fetchCoinAssets()
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    withAnimation(.easeInOut) {
                        router.push(to: .globalChart(viewModel.coins))
                    }
                } label: {
                    Image(systemName: "chart.pie.fill")
                        .font(.body)
                        .bold()
                }
            }
        }
    }
}

extension CryptoListView {
    @ViewBuilder
    private var initialLoadPlaceholders: some View {
        ForEach(initialPlaceholders, id: \.self) { _ in
            RowPlaceholder()
        }
    }
    
    @ViewBuilder
    private var coinListContent: some View {
        let displayList = viewModel.filteredCoin()
        if let errorMessage = viewModel.errorMessage, displayList.isEmpty {
            NetworkErrorView(message: errorMessage) {
                Task {
                    await viewModel.fetchCoinAssets()
                }
            }
        }
        else if displayList.isEmpty && viewModel.isLoading  {
            initialLoadPlaceholders
        } else {
            mainListView(displayList: displayList)
        }
        
    }
    
    @ViewBuilder
    private func mainListView(displayList: [Coin]) -> some View {
        ForEach(displayList) { coin in
            Button {
                router.push(to: .cryptoDetail(coin))
            } label: {
                CryptoListRow(coin: coin)
            }
            .buttonStyle(.plain)
            
            .onAppear {
                if viewModel.searchText.isEmpty && coin.id == viewModel.coins.last?.id {
                    Task { await viewModel.fetchCoinAssets() }
                }
            }
        }
        
        if viewModel.isLoading && !viewModel.coins.isEmpty {
            ForEach(paginationPlaceholders, id: \.self) { _ in
                RowPlaceholder()
            }
        }
    }
}

#Preview {
    CryptoListView(viewModel: CryptoListViewModel())
}
