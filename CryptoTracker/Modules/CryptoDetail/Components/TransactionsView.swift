//
//  TransactionsView.swift
//  CryptoTracker
//
//  Created by Uziel Sabalza on 3/9/26.
//

import SwiftUI
import SwiftData

struct TransactionsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var transactions: [CoinTransaction]
    
    let coinId: String
    let coinName: String
    
    // Filtrar manualmente las transacciones del token actual
    private var filteredTransactions: [CoinTransaction] {
        transactions.filter { $0.coinId == coinId }.sorted(by: { $0.date > $1.date })
    }
    
    var body: some View {
        List {
            if filteredTransactions.isEmpty {
                ContentUnavailableView(
                    "Sin Transacciones",
                    systemImage: "tray.fill",
                    description: Text("Aún no has registrado operaciones para \(coinName).")
                )
            } else {
                ForEach(filteredTransactions) { transaction in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(transaction.type.rawValue)
                                .font(.subheadline)
                                .bold()
                                .foregroundColor(transaction.type == .buy ? .green : .red)
                            Text(transaction.date, style: .date)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("\(transaction.amount.formatted(.number)) \(transaction.coinSymbol.uppercased())")
                                .font(.body)
                                .bold()
                            // Usamos nuestra extensión compactCurrency creada previamente
                            Text(transaction.totalValue.toCompactCurrency())
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }
                .onDelete(perform: deleteTransactions)
            }
        }
        .navigationTitle("Historial de \(coinName)")
        .navigationBarTitleDisplayMode(.large)
    }
    
    private func deleteTransactions(at offsets: IndexSet) {
        for index in offsets {
            let targetTransaction = filteredTransactions[index]
            modelContext.delete(targetTransaction)
        }
    }
}
