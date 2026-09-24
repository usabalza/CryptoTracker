//
//  MarketGridView.swift
//  CryptoTracker
//
//  Created by Uziel Sabalza on 31/8/26.
//

import SwiftUI

struct MarketGridView: View {
    
    let coin: Coin
    
    var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                Text("Estadísticas de Mercado")
                    .font(.headline)
                    .padding(.horizontal)
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                    StatCard(title: "Cap. de Mercado", value: coin.marketCap.toCompactCurrency(), subtitle: "Puesto #\(coin.rank)")
                    StatCard(title: "Volumen (24h)", value: coin.volume.toCompactCurrency(), subtitle: nil)
                    StatCard(title: "Máximo Histórico", value: coin.ath.toCompactCurrency(), subtitle: coin.athDate.stringToDateISO8601().dateToShortDateString())
                    StatCard(title: "Suministro Circulante", value: "\(coin.circulatingSupply.toCompactNumber()) \(coin.symbol.uppercased())", subtitle: "93.8% del total")
                }
                .padding(.horizontal)
            }
        }
}


