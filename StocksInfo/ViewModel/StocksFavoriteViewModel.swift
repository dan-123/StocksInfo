//
//  StocksFavoriteViewModel.swift
//  StocksInfo
//
//  Created by Даниил Петров on 22.02.2021.
//

import UIKit

class StocksFavoriteListViewModel {
    
    // MARK: - Properties
    
    let networkService: NetworkServiceProtocol = NetworkService()
    let dataService: DataServiceProtocol = DataService()
    
    var models = [StockItemModel]()
    
    var onDidDataLoaded: (() -> Void)?
    
    var itemsCount: Int {
        return models.count
    }
    
    var images = [String: UIImage]()
    
    // MARK: - Methods
    
    func loadData() {
        models = dataService.fetchAllFavotites()
        onDidDataLoaded?()
    }
    
    func item(at index: Int) -> StockItemModel {
        return models[index]
    }
    
    func colorForItem(at index: Int) -> UIColor {
        guard let priceChange = item(at: index).priceChange else {
            return .black
        }
        if priceChange > 0 {
            return .systemGreen
        } else if priceChange < 0 {
            return .red
        }
        return .black
    }
    
    func loadImage(for index: Int, completionHandler: ((UIImage?) -> Void)?) {
        guard let symbol = item(at: index).companySymbol else {
            completionHandler?(nil)
            return
        }
        if let image = images[symbol] {
            completionHandler?(image)
        } else {
            networkService.fetchImage(symbol: symbol) { [weak self] image in
                self?.images[symbol] = image
                completionHandler?(image)
            }
        }
    }
    
    func cachedImage(for index: Int) -> UIImage? {
        guard let symbol = item(at: index).companySymbol else {
            return nil
        }
        return images[symbol]
    }
}
