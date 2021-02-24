//
//  DataService.swift
//  StocksInfo
//
//  Created by Даниил Петров on 22.02.2021.
//

import Foundation

protocol DataServiceProtocol {
    func addCompany(model: StockItemModel)
    func deleteCompany(symbol: String)
    func fetchAllFavotites() -> [StockItemModel]
    func isExistCompany(symbol: String) -> Bool
}

class DataService: DataServiceProtocol {
    
    private let stocksKey = "StocksKey"
    private let userDefaults = UserDefaults.standard
    
    // MARK: - Methods
    
    func addCompany(model: StockItemModel) {
//        guard let symbol = model.companySymbol else {
//            return
//        }
        var stocks = fetchAllFavotites()
        stocks.append(model)
        setObject(stocks, forKey: stocksKey)
    }
    
    func deleteCompany(symbol: String) {
        var stocks = fetchAllFavotites()
        stocks.removeAll(where: {$0.companySymbol == symbol})
        setObject(stocks, forKey: stocksKey)
    }
    
    func fetchAllFavotites() -> [StockItemModel] {
        let stocks = getObject(forKey: stocksKey, castTo: [StockItemModel].self)
        return stocks
    }
    
    func isExistCompany(symbol: String) -> Bool {
        let stocks = fetchAllFavotites()
        return stocks.contains(where: {$0.companySymbol == symbol})
    }
   
    // MARK: - Private methods
    
    private func setObject<Object>(_ objects: [Object], forKey: String) where Object: Encodable {
        let encoder = JSONEncoder()
        let data = try? encoder.encode(objects)
        userDefaults.set(data, forKey: forKey)
    }
    
    private func getObject<Object>(forKey: String, castTo type: [Object].Type) -> [Object] where Object: Decodable {
        guard let data = userDefaults.data(forKey: forKey) else {
            return []
        }
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(type, from: data)
            return object
        } catch {
            return []
        }
    }
    
    
}
