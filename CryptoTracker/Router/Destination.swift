//
//  Destination.swift
//  CryptoTracker
//
//  Created by Uziel Sabalza on 5/6/26.
//

public enum Destination: Hashable, Equatable {
    public static func == (lhs: Destination, rhs: Destination) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    case cryptoList
    case cryptoDetail(_ selected: Coin)
    case cryptoTransactions(_ coinId: String, _ coinName: String)
    case globalChart(_ coins: [Coin])
    
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .cryptoList:
            hasher.combine(0)
        case .cryptoDetail(let selected):
            hasher.combine(1)
            hasher.combine(selected.id)
        case .cryptoTransactions(let coinId, let coinName):
            hasher.combine(2)
            hasher.combine(coinId)
            hasher.combine(coinName)
        case .globalChart(let selected):
            hasher.combine(3)
            hasher.combine(selected.map(\.id))
        }
    }
}

/// Representa las pantallas modales (Sheets)
public enum Sheet: Hashable, Identifiable {
    public static func == (lhs: Sheet, rhs: Sheet) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    case addTransaction(_ selected: Coin)
    
    public var id: String {
        switch self {
        case .addTransaction: "addTransaction"
        }
    }
    
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .addTransaction(let selected):
            hasher.combine(1)
            hasher.combine(selected.id)
        }
    }
}
