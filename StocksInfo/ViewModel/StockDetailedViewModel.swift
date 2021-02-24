//
//  StockDetailedViewModel.swift
//  StocksInfo
//
//  Created by Даниил Петров on 22.02.2021.
//

import UIKit

class StockDetailedViewModel {
    
    //MARK: _ Properties
    
    let networkService: NetworkServiceProtocol = NetworkService()
    let dataService: DataServiceProtocol = DataService()
    
    //MARK: - Method
    
    func performFavoriteAction(model: StockItemModel?) {
        guard let symbol = model?.companySymbol, let model = model else {
            return
        }
        if dataService.isExistCompany(symbol: symbol) {
            dataService.deleteCompany(symbol: symbol)
        } else {
            dataService.addCompany(model: model)
        }
    }
    
    func isFavorite(symbol: String?) -> Bool {
        guard let symbol = symbol else {
            return false
        }
        return dataService.isExistCompany(symbol: symbol)
    }
    
    func loadImage(symbol: String, completionHandler: ((UIImage?) -> Void)?) {
        networkService.fetchImage(symbol: symbol) { image in
            completionHandler?(image)
        }
    }
}
