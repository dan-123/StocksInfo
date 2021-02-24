//
//  File.swift
//  StocksInfo
//
//  Created by Даниил Петров on 22.02.2021.
//

import UIKit

protocol NetworkServiceProtocol {
    func fetchStockList(completionHandler: ((Result<[StockItemModel]?, NetworkError>) -> Void)?)
    func fetchImage(symbol: String?, completionHandler: ((UIImage?) -> Void)?)
}

enum NetworkError: LocalizedError {
    case networkError
    case urlError
    
    var errorDescription: String? {
        switch self {
        case .networkError:
            return "We couldn't load data. Please try again later"
        case .urlError:
            return "We couldn't perform request. Please try again later"
        }
    }
}

class NetworkService: NetworkServiceProtocol {
    
    // MARK: - Constants
    
    private struct Constants {
        static let token = "pk_67cf770782e34a109d293c6bffd953ac"
        static let baseURL = "https://cloud.iexapis.com/stable/"
    }
    
    // MARK: - Methods
    
    func fetchStockList(completionHandler: ((Result<[StockItemModel]?, NetworkError>) -> Void)?) {
        let urlString: String = Constants.baseURL + "stock/market/list/gainers?listLimit=50&token=\(Constants.token)"
        guard let url = URL(string: urlString) else {
            completionHandler?(.failure(.urlError))
            return
        }
        baseRequest(url, completionHandler: completionHandler)
    }
    
    func fetchImage(symbol: String?, completionHandler: ((UIImage?) -> Void)?) {
        guard let symbol = symbol else {
            completionHandler?(nil)
            return
        }
        requestLogo(for: symbol, completionHandler: completionHandler)
    }
    
    // MARK: - Private methods
    
    private func baseRequest<T: Codable>(_ url: URL, completionHandler: ((Result<T?, NetworkError>) -> Void)?) {
//        guard let url = URL(string: "https://cloud.iexapis.com/stable/stock/market/list/gainers?listLimit=50&token=\(token)") else {
//            return
//        }
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data,
               (response as? HTTPURLResponse)?.statusCode == 200,
               error == nil {
                let jsonData = try? JSONDecoder().decode(T.self, from: data)
                completionHandler?(.success(jsonData))
            } else {
                print("Network error!")
                completionHandler?(.failure(.networkError))
            }
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            dataTask.resume()
        }
    }
    
    private func requestLogo(for symbol: String, completionHandler: ((UIImage?) -> Void)?) {
        let urlString: String = Constants.baseURL + "stock/\(symbol)/logo?token=\(Constants.token)"
        guard let url = URL(string: urlString) else {
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            if let data = data,
               (response as? HTTPURLResponse)?.statusCode == 200,
               error == nil {
                self?.parseImage(from: data, completionHandler: completionHandler)
            } else {
                completionHandler?(UIImage(named: "stockImage"))
            }
        }
        DispatchQueue.global(qos: .userInitiated).async {
            dataTask.resume()
        }
    }
    
    private func parseImage(from data: Data, completionHandler: ((UIImage?) -> Void)?) {
        do {
            let jsonObject = try JSONDecoder().decode(ImageLinkModel.self, from: data)
            uploadLogo(url: jsonObject.url, completionHandler: completionHandler)
        } catch {
            completionHandler?(UIImage(named: "stockImage"))
        }
    }
    
    private func uploadLogo(url: String, completionHandler: ((UIImage?) -> Void)?) {
        guard let url = URL(string: url) else {
            return
        }
        do {
            let data = try Data(contentsOf: url)
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                completionHandler?(image)
            }
        } catch {
            completionHandler?(UIImage(named: "stockImage"))
        }
    }
}
