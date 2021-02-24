//
//  ContentViewController.swift
//  StocksInfo
//
//  Created by Даниил Петров on 23.02.2021.
//

import UIKit

class ContentViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var presentTextLabel: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    
    // MARK: - Properties
    
    var presentText = ""
    var currentPage = 0
    var numberOfPage = 0
    
    // MARK: - Lyfe cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presentTextLabel.text = presentText
        pageControl.numberOfPages = numberOfPage - 1
        pageControl.currentPage = currentPage
        
    }

}
