//
//  PieChartView.swift
//  CryptoTracker
//
//  Created by Uziel Sabalza on 3/9/26.
//

import SwiftUI
import Charts

struct PieChartView: View {
    let allocations: [AssetAllocation]
    let totalValue: Double
    let colorProvider: (String) -> Color
    
    var body: some View {
        VStack(spacing: 15) {
            ZStack {
                // El gráfico de sectores circulares
                Chart(allocations) { asset in
                    SectorMark(
                        angle: .value("Porcentaje", asset.percentage),
                        innerRadius: .ratio(0.65), // Transforma el gráfico de pastel en una dona elegante
                        angularInset: 2.0     // Pequeña separación estética entre sectores
                    )
                    .foregroundStyle(by: .value("Moneda", asset.symbol.uppercased()))
                    .cornerRadius(5)
                }
                .chartForegroundStyleScale(domain: allocations.map { $0.symbol.uppercased() },
                                                           range: allocations.map { colorProvider($0.symbol) })
                .chartLegend(.hidden) // Ocultamos la leyenda automática para diseñar la nuestra en la lista
                .frame(height: 200)
                
                // Texto central dentro de la dona
                VStack {
                    Text("Balance Total")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(totalValue.toCompactCurrency())
                        .font(.title2)
                        .bold()
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(16)
        .padding(.horizontal)
    }
}
