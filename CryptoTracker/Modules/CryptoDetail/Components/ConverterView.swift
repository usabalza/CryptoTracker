//
//  ConverterView.swift
//  CryptoTracker
//
//  Created by Uziel Sabalza on 2/9/26.
//

import SwiftUI

struct ConverterView: View {
    let coinName: String
    let coinSymbol: String
    
    private enum Field {
        case crypto
        case usd
    }
    
    // Enlazamos las variables bidireccionalmente con el ViewModel principal
    @Binding var cryptoAmount: String
    @Binding var usdAmount: String
    @FocusState private var focusedField: Field?
    
    // Clausuras para avisarle a la vista madre cuándo recalcular
    let onCryptoChanged: () -> Void
    let onUSDChanged: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Calculadora de Conversión")
                .font(.headline)
            
            VStack(spacing: 12) {
                // Fila de Entrada Cripto
                HStack {
                    Text(coinSymbol.uppercased())
                        .font(.callout)
                        .bold()
                        .foregroundColor(.secondary)
                        .frame(width: 80, alignment: .leading)
                    
                    TextField("0.00", text: $cryptoAmount)
                        .keyboardType(.decimalPad)
                        .focused($focusedField, equals: .crypto)
                        .multilineTextAlignment(.trailing)
                        .font(.body)
                        .onChange(of: cryptoAmount) { _, _ in
                            if focusedField == .crypto {
                                onCryptoChanged()
                            }
                        }
                }
                .padding()
                .background(Color(.systemGroupedBackground))
                .cornerRadius(10)
                
                // Icono indicador de intercambio
                Image(systemName: "arrow.up.arrow.down")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                // Fila de Entrada USD
                HStack {
                    Text("USD ($)")
                        .font(.callout)
                        .bold()
                        .foregroundColor(.secondary)
                        .frame(width: 80, alignment: .leading)
                    
                    TextField("0.00", text: $usdAmount)
                        .keyboardType(.decimalPad)
                        .focused($focusedField, equals: .usd)
                        .multilineTextAlignment(.trailing)
                        .font(.body)
                        .onChange(of: usdAmount) { _, _ in
                            if focusedField == .usd {
                                onUSDChanged()
                            }
                        }
                }
                .padding()
                .background(Color(.systemGroupedBackground))
                .cornerRadius(10)
            }
        }
        .padding(.horizontal)
    }
}
