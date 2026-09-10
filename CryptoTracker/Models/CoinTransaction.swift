//
//  Transaction.swift
//  CryptoTracker
//
//  Created by Uziel Sabalza on 3/9/26.
//

import Foundation
import SwiftData

enum TransactionType: String, Codable, CaseIterable {
    case buy = "Compra"
    case sell = "Venta"
}

@Model
final class CoinTransaction {
    var coinId: String
    var coinName: String
    var coinSymbol: String
    var typeString: String
    var amount: Double
    var pricePerCoin: Double
    var date: Date
    
    var type: TransactionType {
        get { TransactionType(rawValue: typeString) ?? .buy }
        set { typeString = newValue.rawValue }
    }
    
    init(coinId: String, coinName: String, coinSymbol: String, type: TransactionType, amount: Double, pricePerCoin: Double, date: Date = Date()) {
        self.coinId = coinId
        self.coinName = coinName
        self.coinSymbol = coinSymbol
        self.typeString = type.rawValue
        self.amount = amount
        self.pricePerCoin = pricePerCoin
        self.date = date
    }
    
    var totalValue: Double {
        return amount * pricePerCoin
    }
}

extension CoinTransaction {
    static func createMock(id: String, name: String, symbol: String) -> CoinTransaction {
        return CoinTransaction(
            coinId: id,
            coinName: name,
            coinSymbol: symbol,
            type: .buy,
            amount: 10.0,
            pricePerCoin: 1.0)
        
    }
}
