//
//  MyHoldingsView.swift
//  CryptoTracker
//
//  Created by Uziel Sabalza on 3/9/26.
//

import SwiftUI

struct MyHoldingsView: View {
    let chartColor: Color
    let goToTransactions: () -> Void
    let addTransaction: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Tus Holdings")
                    .font(.headline)
                Spacer()
                
                Button {
                    goToTransactions()
                } label: {
                    Text("Ver todas")
                        .font(.subheadline)
                        .bold()
                }
            }
            .padding(.horizontal)
            
            Button {
                addTransaction()
            } label: {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Registrar Compra / Venta")
                }
                .font(.body)
                .bold()
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(chartColor)
                .cornerRadius(12)
            }
            .padding(.horizontal)
        }
        .padding(.bottom, 40)
    }
}
