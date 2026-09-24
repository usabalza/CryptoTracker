//
//  AddTransactionView.swift
//  CryptoTracker
//
//  Created by Uziel Sabalza on 3/9/26.
//

import SwiftUI
import SwiftData

struct AddTransactionView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    let coinId: String
    let coinName: String
    let coinSymbol: String
    let currentPrice: Double
    
    @State private var transactionType: TransactionType = .buy
    @State private var amountString: String = ""
    @State private var priceString: String = ""
    
    var body: some View {
        Form {
            Section("Tipo de Operación") {
                Picker("Tipo", selection: $transactionType) {
                    ForEach(TransactionType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(.segmented)
            }
            
            Section("Detalles de la Transacción") {
                HStack {
                    Text("Cantidad (\(coinSymbol.uppercased()))")
                    TextField("0.00", text: $amountString)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                }
                
                HStack {
                    Text("Precio por unidad (USD)")
                    TextField("0.00", text: $priceString)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                }
            }
            
            Section {
                HStack {
                    Button("Cancelar") {
                        dismiss()
                    }
                    .font(.body)
                    .bold()
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.red)
                    .cornerRadius(12)
                    
                    Button("Guardar") {
                        saveTransaction()
                    }
                    .disabled(amountString.isEmpty || priceString.isEmpty)
                    .font(.body)
                    .bold()
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(amountString.isEmpty || priceString.isEmpty ? .gray : .green)
                    .cornerRadius(12)
                }
            }
        }
        .onAppear {
            // Auto-rellenar con el precio actual de CoinGecko
            priceString = currentPrice.toCurrency()
        }
    }
    
    private func saveTransaction() {
        guard let amount = Double(amountString), let price = Double(priceString) else { return }
        
        let newTransaction = CoinTransaction(
            coinId: coinId,
            coinName: coinName,
            coinSymbol: coinSymbol,
            type: transactionType,
            amount: amount,
            pricePerCoin: price
        )
        
        modelContext.insert(newTransaction)
        dismiss()
    }
}
