//
//  UnsplashSearchController.swift
//  UnsplashPhotoPicker
//
//  Created by Bichon, Nicolas on 2018-12-10.
//  Copyright © 2018 Unsplash. All rights reserved.
//

import UIKit

class UnsplashSearchController: UISearchController {
    lazy var customSearchBar = CustomSearchBar(frame: CGRect.zero)

    override var searchBar: UISearchBar {
        customSearchBar.showsCancelButton = false
        return customSearchBar
    }
}

class CustomSearchBar: UISearchBar {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureAppearance()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureAppearance()
    }

    private func configureAppearance() {
        if let color = Configuration.shared.backgroundColor {
            self.searchTextField.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.8)
            self.searchTextField.textColor = .label
            self.searchTextField.layer.cornerRadius = 8
            self.searchTextField.clipsToBounds = true

            let bgView = subviews.first
            bgView?.backgroundColor = UIColor(color)
            bgView?.subviews.forEach { $0.backgroundColor = UIColor(color) }
        }
    }

    override func setShowsCancelButton(_ showsCancelButton: Bool, animated: Bool) {
        super.setShowsCancelButton(false, animated: false)
    }
}
