//
//  StocksDetail.swift
//  StocksInfo
//
//  Created by Даниил Петров on 21.02.2021.
//

import UIKit

class StockDetail: UIViewController {
   
    // MARK: - Properties
    
    var model: StockItemModel?
    var viewModel = StockDetailedViewModel()
    
    lazy var favoriteCompanyButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "star"),
                                     style: .plain,
                                     target: self,
                                     action: #selector(favoriteAction(_:)))
        return button
    }()
    
    //MARK: - Outlets
    
    @IBOutlet weak var companyLogoImage: UIImageView!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var companySymbolLabel: UILabel!
    @IBOutlet weak var companyPriceLabel: UILabel!
    @IBOutlet weak var companyPriceChangeLabel: UILabel!
    
    //MARK: - Lyfe cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = model?.companySymbol
        navigationItem.rightBarButtonItem = favoriteCompanyButton
        
        if let symbol = model?.companySymbol {
            viewModel.loadImage(symbol: symbol) { [weak self] image in
                self?.companyLogoImage.image = image
            }
        }
        
        companyNameLabel.text = model?.companyName
        companySymbolLabel.text = model?.companySymbol
        
        if let price = model?.price {
            companyPriceLabel.text = "\(price)"
        }
        if let priceChange = model?.priceChange {
            companyPriceChangeLabel.text = "\(priceChange)"
        }
        
        guard let priceChange = model?.priceChange else {
            return
        }
        
        if priceChange > 0 {
            companyPriceChangeLabel.textColor = .systemGreen
        } else  if priceChange < 0 {
            companyPriceChangeLabel.textColor = .red
        }
        configureBarButton()
    }
    
    //MARK: - Methods
    func displayStockInfo(model: StockItemModel) {
        self.model = model
    }
    
    func configureBarButton() {
        let isFavorite: Bool = viewModel.isFavorite(symbol: model?.companySymbol)
        let image = isFavorite ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        favoriteCompanyButton.image = image
    }
    
    // MARK: - Actions
    
    @objc
    func favoriteAction(_ sender: UIBarButtonItem) {
        print("Favorite action")
        viewModel.performFavoriteAction(model: model)
        configureBarButton()
    }
}
