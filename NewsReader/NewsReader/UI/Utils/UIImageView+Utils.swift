//
//  UIImageView+Utils.swift
//  NewsReader
//
//  Created by Tina  on 24.01.26.
//

import UIKit

extension UIImageView {
    convenience init(image: UIImage? = nil, contentMode: UIView.ContentMode) {
        self.init(image: image)
        self.contentMode = contentMode
    }
}

