//
//  UnsplashPhoto+DragAndDrop.swift
//  UnsplashPhotoPicker
//
//  Created by Bichon, Nicolas on 2018-10-09.
//  Copyright © 2018 Unsplash. All rights reserved.
//

import UIKit

extension UnsplashPhoto {
    var itemProvider: NSItemProvider {
        return NSItemProvider(object: UnsplashPhotoItemProvider(with: self))
    }

    var dragItem: UIDragItem {
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = self
        dragItem.previewProvider = {
            let imageView = UIImageView()
            imageView.backgroundColor = self.color
            imageView.layer.cornerRadius = 12
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFill
            imageView.frame.size.width = 300
            imageView.frame.size.height = 300 * CGFloat(self.height) / CGFloat(self.width)

            let parameters = UIDragPreviewParameters()
            parameters.backgroundColor = .clear

            return UIDragPreview(view: imageView, parameters: parameters)
        }
        return dragItem
    }
}
