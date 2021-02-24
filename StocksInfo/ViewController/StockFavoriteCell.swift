//
//  StockFavoriteCell.swift
//  StocksInfo
//
//  Created by Даниил Петров on 22.02.2021.
//

import UIKit

class StockFavoriteCell: UITableViewCell {

    //MARK: - Lyfe cycle
    
    @IBOutlet weak var companyLogoImage: UIImageView!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var priceChangeLabel: UILabel!
    
    //MARK: - Lyfe cycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        companyLogoImage.image = nil
        priceChangeLabel.text = nil
        companyNameLabel.text = nil
        priceChangeLabel.textColor = .black
    }
    
    // MARK: - Methods
    
    func companyInfo(symbol: String,
                     companyName: String?,
                     priceChange: Double,
                     priceColor: UIColor) {
        companyNameLabel.text = companyName
        priceChangeLabel.text = "\(priceChange)"
        priceChangeLabel.textColor = priceColor
//        requestLogo(for: symbol)
    }
    
    func update(image: UIImage?) {
        DispatchQueue.main.async {
            self.companyLogoImage.image = image
        }
    }
}
