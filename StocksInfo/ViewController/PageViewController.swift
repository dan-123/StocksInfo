//
//  PageViewController.swift
//  StocksInfo
//
//  Created by Даниил Петров on 23.02.2021.
//

import UIKit

class PageViewController: UIPageViewController {

    let presentSrceenContent = [
        "Добро пожаловать в приложение Акции",
        "Отслеживайте цены на акции",
        "Добавляете интересующие вас компании в список избранных компаний",
        ""
    ]
    
    // MARK: - Lyfe cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self

        if let contentViewController = showViewControllerAtIndex(0) {
            setViewControllers([contentViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    // MARK: - Methods
    
    func showViewControllerAtIndex(_ index: Int) -> ContentViewController? {
        guard index >= 0 else {
            return nil
        }
        guard index < presentSrceenContent.count else {
            let userDefaults = UserDefaults.standard
            userDefaults.set(true, forKey: "presentationWasViewed")
            dismiss(animated: true, completion: nil)
            return nil
        }
        guard let contentViewController = storyboard?.instantiateViewController(identifier: "ContentViewController") as? ContentViewController else {
            return nil
        }
        
        contentViewController.presentText = presentSrceenContent[index]
        contentViewController.currentPage = index
        contentViewController.numberOfPage = presentSrceenContent.count
        
        return contentViewController
    }

}

// MARK: - PageViewController data source

extension PageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var pageNumber = (viewController as? ContentViewController)?.currentPage ?? 0
        pageNumber -= 1
        
        return showViewControllerAtIndex(pageNumber)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var pageNumber = (viewController as? ContentViewController)?.currentPage ?? 0
        pageNumber += 1
        
        return showViewControllerAtIndex(pageNumber)
    }
}
