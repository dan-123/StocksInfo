//
//  StocksList.swift
//  StocksInfo
//
//  Created by Даниил Петров on 21.02.2021.
//

import UIKit

class StocksList: UITableViewController {
    
    let viewModel = StocksListViewModel()
    
    //MARK: - Lyfe cycle
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        
        startPresentation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Stocks"
        bindViewModel()
        viewModel.loadData()
    }

    // MARK: - Methods
    func startPresentation() {
        let userDefaults = UserDefaults.standard
        let presentationWasViewed = userDefaults.bool(forKey: "presentationWasViewed")
        //let presentationWasViewed = false
        
        if presentationWasViewed == false {
            if let pageViewController = storyboard?.instantiateViewController(identifier: "PageViewController") as? PageViewController {
                present(pageViewController, animated: true, completion: nil)
            }
        }
        
    }
    
    // MARK: - Private methods
    
    private func bindViewModel() {
        viewModel.onDidDataLoaded = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    // MARK: - TableView data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.itemsCount
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "List", for: indexPath) as! StockInfoCell
        
        let model = viewModel.item(at: indexPath.row)
        
        cell.companyInfo(symbol: model.companySymbol ?? "",
                         companyName: model.companyName ?? "",
                         priceChange: model.priceChange ?? 0.0,
                         priceColor: viewModel.colorForItem(at: indexPath.row))
        
        viewModel.loadImage(for: indexPath.row) { image in
            cell.update(image: image)
        }
        return cell
    }
    
    // MARK: - TableView delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Select item \(indexPath.row)")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "StocksDetailViewController") as? StockDetail else {
            return
        }
        let model = viewModel.item(at: indexPath.row)
        
        viewController.displayStockInfo(model: model)
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    

}
