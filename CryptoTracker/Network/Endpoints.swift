//
//  Endpoints.swift
//  CryptoTracker
//
//  Created by Uziel Sabalza on 22/8/26.
//

import Foundation

enum Endpoints {
    case baseUrl
    case coins(limit: Int, offset: Int)
    case marketChart(coinId: String, days: String)
    
    private var baseString: String {
        //return "https://api.coinpaprika.com/v1/"
        return "https://api.coingecko.com/api/v3/"
    }
    
    var apiKey: String {
        return "CG-7WhLFPcJZgDmNgSogCesVgDK"
    }
    
    var urlString: String {
        switch self {
        case .baseUrl:
            return baseString
        case .coins(let limit, let offset):
            guard var components = URLComponents(string: "\(baseString)coins/markets") else { return "" }
            components.queryItems = [
                URLQueryItem(name: "vs_currency", value: "usd"),
                URLQueryItem(name: "per_page", value: "\(limit)"),
                URLQueryItem(name: "page", value: "\(offset)")
            ]
            return components.url?.absoluteString ?? ""
        case .marketChart(let coinId, let days):
            guard var components = URLComponents(string: "\(baseString)coins/\(coinId)/market_chart") else { return "" }
            components.queryItems = [
                URLQueryItem(name: "vs_currency", value: "usd"),
                URLQueryItem(name: "days", value: days)
            ]
            return components.url?.absoluteString ?? ""
        }
    }
}
