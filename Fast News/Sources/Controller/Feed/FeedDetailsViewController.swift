//
//  FeedDetailsViewController.swift
//  Fast News
//
//  Copyright © 2019 Lucas Moreton. All rights reserved.
//

import UIKit

class FeedDetailsViewController: UIViewController {
    
    //MARK: - Properties
    
    var hotNewsViewModel: HotNewsViewModel?
    var isLoading = false
    
    var comments: [Comment] = [Comment]() {
        didSet {
            var viewModels: [TypeProtocol] = [TypeProtocol]()
            
            if let hotNews = hotNewsViewModel {
                viewModels.append(hotNews)
            }
            
            _ = comments.map { (comment) in
                viewModels.append(CommentViewModel(comment: comment))
            }
            
            self.mainView.setup(with: viewModels, and: self)
            if isLoading {
                stopLoading()
                isLoading = false
            }
        }
    }
    
    var mainView: FeedDetailsView {
        guard let view = self.view as? FeedDetailsView else {
            fatalError("View is not of type FeedDetailsView!")
        }
        return view
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startLoading(withMessage: "Loading comments...", completionHandler: fetchComments)
        isLoading = true
        setupNavigationBar()
    }
    
    private func fetchComments() {
        HotNewsProvider.shared.hotNewsComments(id: hotNewsViewModel?.id ?? "") { (completion) in
            do {
                let comments = try completion()
                
                self.comments = comments
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func setupNavigationBar() {
        let buttonImage: UIImage?
        if #available(iOS 13.0, *) {
            buttonImage = UIImage(systemName: "square.and.arrow.up")
        } else {
            buttonImage = UIImage(named: "share_icon")
        }
        
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: buttonImage, style: .plain, target: self, action: #selector(shareUrl))
    }
    
    @objc private func shareUrl() {
        let url = URL(string: hotNewsViewModel?.url ?? "")
        let urlToShare = [url]
        let activityViewController = UIActivityViewController(activityItems: urlToShare as [Any], applicationActivities: nil)
        
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.postToFacebook ]
        
        self.present(activityViewController, animated: true, completion: nil)
    }
}

extension FeedDetailsViewController: FeedDelegate {
    func didTouch(cell: FeedCell, indexPath: IndexPath) {
        guard self.mainView.viewModels[indexPath.row].type == .hotNews,
            let viewModel = self.mainView.viewModels[indexPath.row] as? HotNewsViewModel else {
                return
        }
        
        if let url = URL(string: viewModel.url) {
            UIApplication.shared.open(url)
        }
    }
}
