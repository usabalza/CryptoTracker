//
//  CryptoListRow.swift
//  CryptoTracker
//
//  Created by Uziel Sabalza on 5/6/26.
//

import SwiftUI

struct CryptoListRow: View {
    
    var coin: Coin
    
    var body: some View {
        HStack(alignment: .center, spacing: 20) {
            ZStack {
                Circle()
                    .fill(Color(.systemGray6))
                    .frame(width: 60, height: 60)
                
                AsyncImage(url: URL(string: coin.image)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    Circle()
                        .fill(Color(.systemGray5))
                }
                .frame(width: 60, height: 60)
                
            }
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    
                    Text(coin.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(coin.symbol.uppercased())
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Text(coin.currentPrice.toCurrency())
                    .font(.body)
                
            }
            Spacer()
            
            HStack(spacing: 6) {
                Text(coin.percentChange24h.asPercentString)
                Image(systemName: setArrow())
            }
            .font(.title3)
            .bold()
            .foregroundStyle(setColor())
        }
        .contentShape(Rectangle())
        .frame(maxWidth: .infinity)
        .padding()
        
    }
    
    private func setColor() -> Color {
        guard let percentChange24h = coin.percentChange24h else { return .gray }
        
        return percentChange24h.isLess(than: 0) ? .red : .green
    }
    
    private func setArrow() -> String {
        guard let percentChange24h = coin.percentChange24h else { return "questionmark" }
        
        return percentChange24h.isLess(than: 0) ? "arrow.down.right" : "arrow.up.right"
    }
}

