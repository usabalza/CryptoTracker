//
//  GlobalChartView.swift
//  CryptoTracker
//
//  Created by Uziel Sabalza on 3/9/26.
//

import SwiftUI
import SwiftData

struct GlobalChartView: View {
    @EnvironmentObject var router: Router
    @StateObject var viewModel: GlobalChartViewModel
    @Query private var allTransactions: [CoinTransaction]
    
    init(coins: [Coin]) {
        self._viewModel = StateObject(wrappedValue: GlobalChartViewModel(coins: coins))
    }
    
    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.allocations.isEmpty {
                ProgressView("Calculando gráfico...")
            } else if viewModel.allocations.isEmpty {
                // Estado vacío si el usuario no ha comprado nada aún
                ContentUnavailableView(
                    "Tu gráfico está Vacío",
                    systemImage: "chart.pie",
                    description: Text("Registra tus primeras operaciones de compra o venta dentro del detalle de cualquier moneda.")
                )
            } else {
                mainView
            }
        }
        .navigationTitle("Gráfico global")
        .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
        // Sincronizar los datos automáticamente cuando cambien las transacciones en la Base de Datos
        .onChange(of: allTransactions) { _, newTransactions in
            Task {
                await viewModel.refreshGlobalChart(transactions: newTransactions)
            }
        }
        // Primera carga al abrir la aplicación
        .task {
            await viewModel.refreshGlobalChart(transactions: allTransactions)
        }
    }
}

extension GlobalChartView {
    @ViewBuilder
    private var mainView: some View {
        ScrollView {
            VStack(spacing: 22) {
                // 1. Gráfico de distribución superior
                PieChartView(
                    allocations: viewModel.allocations,
                    totalValue: viewModel.totalValue,
                    colorProvider: { symbol in
                        colorForAsset(symbol: symbol)
                    }
                )
                
                HoldingList(allocations: viewModel.allocations) { symbol in
                    guard let coin = viewModel.coins.first(where: { $0.symbol == symbol }) else { return }
                    router.push(to: .cryptoDetail(coin))
                } colorProvider: { symbol in
                    colorForAsset(symbol: symbol)
                }
                
            }
            .padding(.top, 10)
        }
    }
}

extension GlobalChartView {
    /// Devuelve un color consistente del sistema para cada moneda de forma única
    func colorForAsset(symbol: String) -> Color {
        let colors: [Color] = [.blue, .green, .purple, .orange, .cyan, .pink, .indigo, .teal, .yellow]
        
        // Generamos un identificador numérico (Hash) basado en las letras del símbolo
        let hash = abs(symbol.hashValue)
        
        // Usamos el residuo (módulo) para elegir un color de la lista sin salirnos del rango
        return colors[hash % colors.count]
    }
}
