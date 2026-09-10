//
//  HoldingList.swift
//  CryptoTracker
//
//  Created by Uziel Sabalza on 3/9/26.
//

import SwiftUI

struct HoldingList: View {
    
    let allocations: [AssetAllocation]
    let navigateToCoin: (String) -> Void
    let colorProvider: (String) -> Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Tus Activos")
                .font(.headline)
                .padding(.horizontal)
            
            ForEach(allocations) { asset in
                // Navegación directa reutilizando la pantalla de detalle modular que creamos antes
                Button {
                    navigateToCoin(asset.symbol)
                } label: {
                    HStack {
                        // Indicador de color circular de la lista
                        Circle()
                            .frame(width: 10, height: 10)
                        // SwiftUI asigna colores automáticos consistentes por nombre en los gráficos
                            .foregroundStyle(colorProvider(asset.symbol))
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(asset.name)
                                .font(.body)
                                .bold()
                                .foregroundColor(.primary)
                            Text("\(asset.totalTokens.formatted()) \(asset.symbol.uppercased())")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            Text(asset.totalValueUSD.toCompactCurrency())
                                .font(.body)
                                .bold()
                                .foregroundColor(.primary)
                            Text(String(format: "%.1f%%", asset.percentage))
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    .background(Color(.secondarySystemGroupedBackground))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }

                
            }
        }
    }
}
