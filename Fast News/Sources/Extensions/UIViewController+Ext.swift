//
//  UIViewController+Ext.swift
//  Fast News
//
//  Created by Pablo Henrique Borsone on 15/11/20.
//  Copyright © 2020 Lucas Moreton. All rights reserved.
//

import UIKit

extension UIViewController {
    func startLoading(withMessage message: String, completionHandler: (() -> Void)?) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.color = .orange
        loadingIndicator.style = .gray
        loadingIndicator.startAnimating()

        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: completionHandler)
    }
    
    func stopLoading() {
        dismiss(animated: true, completion: nil)
    }
}
