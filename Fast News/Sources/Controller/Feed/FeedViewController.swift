//
//  FeedViewController.swift
//  Fast News
//
//  Copyright © 2019 Lucas Moreton. All rights reserved.
//

import Foundation
import UIKit

class FeedViewController: UIViewController {
    
    //MARK: - Constants
    
    let kToDetails: String = "toDetails"
    
    // IsLoading flag
    var isLoading = false
    
    //MARK: - Properties
    
    var hotNews: [HotNews] = [HotNews]() {
        didSet {
            var viewModels: [HotNewsViewModel] = [HotNewsViewModel]()
            _ = hotNews.map { (news) in
                viewModels.append(HotNewsViewModel(hotNews: news))
            }
            
            self.mainView.setup(with: viewModels, and: self)
            if isLoading {
                self.stopLoading()
                isLoading = false
            }
            DataPersistence.shared.saveData(items: hotNews)
        }
    }
    
    var mainView: FeedView {
        guard let view = self.view as? FeedView else {
            fatalError("View is not of type FeedView!")
        }
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        guard Connectivity.isConnectedToInternet else {
            if let hotNews =  DataPersistence.shared.loadData() {
                self.hotNews = hotNews
            }
            return
        }
        startLoading(withMessage: "Loading news...", completionHandler: fetchNews)
        isLoading = true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let hotNewsViewModel = sender as? HotNewsViewModel else { return }
        guard let detailViewController = segue.destination as? FeedDetailsViewController else { return }
        
        detailViewController.hotNewsViewModel = hotNewsViewModel
    }
    
    private func fetchNews() {
        HotNewsProvider.shared.hotNews() { (completion) in
            do {
                let hotNews = try completion()

                self.hotNews.append(contentsOf: hotNews)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Fast News"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

extension FeedViewController: FeedViewDelegate {
    func didTouch(cell: FeedCell, indexPath: IndexPath) {
        self.performSegue(withIdentifier: kToDetails, sender: self.mainView.viewModels[indexPath.row])
    }
    
    func didUpdate() {
        guard !HotNewsProvider.shared.isBeingFetched else { return }
        fetchNews()
    }
}
