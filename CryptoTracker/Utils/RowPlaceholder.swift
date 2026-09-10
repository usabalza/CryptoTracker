//
//  RowPlaceholder.swift
//  CryptoTracker
//
//  Created by Uziel Sabalza on 3/9/26.
//

import SwiftUI

struct RowPlaceholder: View {
    var body: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(Color.gray)
                .frame(width: 60, height: 60)
            
            VStack(alignment: .leading, spacing: 8) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray)
                    .frame(width: 40, height: 12)
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray)
                    .frame(width: 140, height: 18)
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
        .shimmer()
    }
}
