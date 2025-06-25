//
//  PhotoCell.swift
//  Unsplash
//
//  Created by Olivier Collet on 2017-07-26.
//  Copyright © 2017 Unsplash. All rights reserved.
//

import SwiftUI

class PhotoCell: UICollectionViewCell {

    // MARK: - Properties

    static let reuseIdentifier = "PhotoCell"

    private lazy var checkmarkView: CheckmarkView = {
        return CheckmarkView()
    }()

    private var photo: UnsplashPhoto?

    override var isSelected: Bool {
        didSet {
            updateSelectedState()
        }
    }

    // MARK: - Lifetime

    override init(frame: CGRect) {
        super.init(frame: frame)
        postInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        postInit()
    }

    private func postInit() {
        setupCheckmarkView()
        updateSelectedState()
    }

    private func updateSelectedState() {
        if #available(iOS 16.0, *) {
            // UIHostingConfiguration handles alpha internally, so no need to change alpha here for the hosted view.
            checkmarkView.alpha = isSelected ? 1 : 0
        } else {
            // Fallback for earlier iOS versions if needed
            checkmarkView.alpha = isSelected ? 1 : 0
        }
    }

    // Override to bypass some expensive layout calculations.
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        return .zero
    }

    // MARK: - Setup

    func configure(with photo: UnsplashPhoto) {
        self.photo = photo
        if #available(iOS 16.0, *) {
            let config = UIHostingConfiguration {
                PhotoView(photo: photo, showsUsername: true)
            }
            UIView.transition(with: self.contentView, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.contentConfiguration = config
            }, completion: nil)
        }
    }

    private func setupCheckmarkView() {
        checkmarkView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(checkmarkView)
        NSLayoutConstraint.activate([
            contentView.rightAnchor.constraint(equalToSystemSpacingAfter: checkmarkView.rightAnchor, multiplier: CGFloat(1)),
            contentView.bottomAnchor.constraint(equalToSystemSpacingBelow: checkmarkView.bottomAnchor, multiplier: CGFloat(1))
            ])
    }
}
