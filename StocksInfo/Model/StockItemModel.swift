//
//  StockItemModel.swift
//  StocksInfo
//
//  Created by Даниил Петров on 22.02.2021.
//

import Foundation

struct StockItemModel: Codable {
    let companyName: String?
    let companySymbol: String?
    let price: Double?
    let priceChange: Double?
    
    enum CodingKeys: String, CodingKey {
        case companyName
        case companySymbol = "symbol"
        case price = "latestPrice"
        case priceChange = "change"
    }
}
