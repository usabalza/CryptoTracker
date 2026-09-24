//
//  SummaryView.swift
//  CryptoTracker
//
//  Created by Uziel Sabalza on 3/9/26.
//

import SwiftUI

struct SummaryView: View {
    let summary: CoinPositionSummary
    let coinSymbol: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Tu Balance")
                .font(.headline)
            
            VStack(spacing: 12) {
                // Balance Total Principal
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Valor de tus Activos")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(summary.currentHoldingValue.toCompactCurrency())
                            .font(.system(.title, design: .rounded))
                            .bold()
                    }
                    Spacer()
                    
                    // Badge indicador de Ganancia / Pérdida
                    if summary.hasHoldings {
                        Text(summary.totalProfitLossPercentage >= 0 ? "+\(String(format: "%.2f", summary.totalProfitLossPercentage))%" : "\(String(format: "%.2f", summary.totalProfitLossPercentage))%")
                            .font(.caption)
                            .bold()
                            .foregroundColor(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(summary.totalProfitLossUSD >= 0 ? Color.green : Color.red)
                            .cornerRadius(8)
                    }
                }
                
                Divider()
                
                // Fila Secundaria de Datos Técnicos
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Tokens totales")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Text("\(summary.totalTokens.formatted()) \(coinSymbol.uppercased())")
                            .font(.subheadline)
                            .bold()
                    }
                    Spacer()
                    VStack(alignment: .center, spacing: 2) {
                        Text("Precio Promedio")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Text(summary.averageBuyPrice.toCompactCurrency())
                            .font(.subheadline)
                            .bold()
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("Rendimiento Neto")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Text(summary.totalProfitLossUSD.toCompactCurrency())
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(summary.totalProfitLossUSD >= 0 ? .green : .red)
                    }
                }
            }
            .padding()
            .background(Color(.secondarySystemGroupedBackground))
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.03), radius: 10, x: 0, y: 5)
        }
        .padding(.horizontal)
    }
}
