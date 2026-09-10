//
//  PickerView.swift
//  CryptoTracker
//
//  Created by Uziel Sabalza on 2/9/26.
//

import SwiftUI

struct PickerView: View {
    
    @Binding var selectedRange: TimeRange
    
    var body: some View {
        Picker("Rango de Tiempo", selection: $selectedRange) {
            ForEach(TimeRange.allCases) { range in
                Text(range.rawValue).tag(range)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
    }
}
