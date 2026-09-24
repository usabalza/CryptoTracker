//
//  NetworkErrorView.swift
//  CryptoTracker
//
//  Created by Uziel Sabalza on 9/9/26.
//

import SwiftUI

struct NetworkErrorView: View {
    let message: String
    var onRetryTapped: () -> Void
    
    var body: some View {
        ContentUnavailableView {
            Label("Error de Conexión", systemImage: "wifi.exclamationmark")
                .font(.title2)
                .bold()
        } description: {
            VStack(spacing: 8) {
                Text("No pudimos conectar con la PokéAPI. Revisa tu conexión a internet e inténtalo de nuevo.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                Text(message)
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
                    .italic()
            }
            .padding(.horizontal, 24)
        } actions: {
            Button(action: onRetryTapped) {
                Text("Reintentar")
                    .fontWeight(.semibold)
                    .padding(.horizontal, 24)
            }
            .buttonStyle(.borderedProminent)
            .tint(.blue)
        }
        .padding(.top, 60)
    }
}
