//
//  ChartView.swift
//  CryptoTracker
//
//  Created by Uziel Sabalza on 24/8/26.
//

import SwiftUI
import Foundation
import Charts

struct ChartView: View {
    
    let priceHistory: [PricePoint]
    let isLoading: Bool
    let chartColor: Color
    
    @State private var selectedPoint: PricePoint? = nil
    @State private var isDragging: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Group {
                if let selectedPoint = selectedPoint, isDragging {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(selectedPoint.price.toCurrency())
                            .font(.title2)
                            .foregroundColor(chartColor)
                            .bold()
                        Text(selectedPoint.date, format: .dateTime.day().month().hour().minute())
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                } else {
                    VStack(alignment: .leading, spacing: 2) {
                        // Precio actual (último registrado en el historial)
                        if let latestPrice = priceHistory.last?.price {
                            Text(latestPrice.toCurrency())
                                .font(.title2)
                                .bold()
                        }
                        Text("Rendimiento del periodo")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.horizontal)
            .frame(height: 50, alignment: .leading)
        }
        
        ZStack {
            if isLoading {
                ProgressView("Cargando gráfico...")
                    .frame(height: 250)
            } else if priceHistory.isEmpty {
                Text("No hay datos históricos disponibles.")
                    .foregroundColor(.secondary)
                    .frame(height: 250)
            } else {
                // Inicialización de Swift Charts
                Chart {
                    ForEach(priceHistory) { point in
                        // 1. Dibujar la línea del precio
                        LineMark(
                            x: .value("Fecha", point.date),
                            y: .value("Precio", point.price)
                        )
                        .foregroundStyle(chartColor)
                        .interpolationMethod(.catmullRom) // Suaviza las esquinas de la línea
                        
                        // 2. Relleno sombreado debajo de la línea
                        AreaMark(
                            x: .value("Fecha", point.date),
                            yStart: .value("Base", computeYScaleDomain().lowerBound),
                            yEnd: .value("Precio", point.price)
                        )
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(colors: [chartColor.opacity(0.3), chartColor.opacity(0.0)]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .interpolationMethod(.catmullRom)
                    }
                    if let selectedPoint = selectedPoint, isDragging {
                        RuleMark(x: .value("Selección", selectedPoint.date))
                            .foregroundStyle(Color.secondary.opacity(0.5))
                            .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                        // Punto indicador sobre la línea del gráfico
                            .annotation(position: .top, alignment: .center) {
                                Circle()
                                    .fill(chartColor)
                                    .frame(width: 10, height: 10)
                                    .shadow(radius: 2)
                            }
                    }
                }
                // Configuración visual adicional de la gráfica
                .chartXAxis {
                    let totalTimeInterval = (priceHistory.last?.date.timeIntervalSince1970 ?? 0) - (priceHistory.first?.date.timeIntervalSince1970 ?? 0)
                    let oneDayInSeconds: TimeInterval = 86400
                    
                    // Si la diferencia es menor o igual a un día (86,400 segundos), es el rango 1D
                    if totalTimeInterval <= oneDayInSeconds { // Si es 1D (CoinGecko da datos por hora)
                        AxisMarks(values: .stride(by: .hour, count: 6)) { _ in
                            AxisGridLine()
                            AxisTick()
                            AxisValueLabel(format: .dateTime.hour(.twoDigits(amPM: .omitted)).minute(.twoDigits))
                        }
                    } else { // Si es 7D o 30D
                        AxisMarks(values: .stride(by: .day, count: priceHistory.count > 200 ? 7 : 2)) { _ in
                            AxisGridLine()
                            AxisTick()
                            AxisValueLabel(format: .dateTime.day().month())
                        }
                    }
                }
                
                .chartYScale(domain: computeYScaleDomain()) // Evita que la gráfica toque los bordes
                .frame(height: 250)
                .padding(.horizontal)
                .chartOverlay { proxy in
                    GeometryReader { geo in
                        Rectangle()
                            .fill(Color.clear)
                            .contentShape(Rectangle()) // Hace interactiva toda el área
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { value in
                                        isDragging = true
                                        // Traducir la posición del dedo en una fecha de la gráfica
                                        if let date: Date = proxy.value(atX: value.location.x) {
                                            // Buscar el punto más cercano en nuestro arreglo de datos
                                            selectedPoint = priceHistory.min(by: {
                                                abs($0.date.timeIntervalSince(date)) < abs($1.date.timeIntervalSince(date))
                                            })
                                        }
                                    }
                                    .onEnded { _ in
                                        // Ocultar el tooltip al levantar el dedo
                                        isDragging = false
                                        selectedPoint = nil
                                    }
                            )
                    }
                }
            }
        }
        
        Spacer()
    }
    
    private func computeYScaleDomain() -> ClosedRange<Double> {
        let prices = priceHistory.map { $0.price }
        guard let minPrice = prices.min(), let maxPrice = prices.max() else { return 0...100 }
        let padding = (maxPrice - minPrice) * 0.1 // 10% de margen arriba y abajo
        return (minPrice - padding)...(maxPrice + padding)
    }
}
