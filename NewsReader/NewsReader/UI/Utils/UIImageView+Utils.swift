//
//  UIImageView+Utils.swift
//  NewsReader
//

import UIKit

extension UIImageView {
    convenience init(image: UIImage? = nil, contentMode: UIView.ContentMode) {
        self.init(image: image)
        self.contentMode = contentMode
    }
}

