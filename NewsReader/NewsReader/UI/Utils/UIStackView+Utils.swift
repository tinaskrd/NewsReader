//
//  UIStackView+Utils.swift
//  NewsReader
//

import UIKit

extension UIStackView {
    convenience init(
        arrangedSubviews: [UIView] = [],
        axis: NSLayoutConstraint.Axis,
        distribution: UIStackView.Distribution = .fill,
        alignment: UIStackView.Alignment = .fill,
        spacing: CGFloat = 0
    ) {
        self.init(arrangedSubviews: arrangedSubviews)
        addArrangedSubviews(arrangedSubviews)
        self.axis = axis
        self.distribution = distribution
        self.alignment = alignment
        self.spacing = spacing
    }

    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { addArrangedSubview($0) }
    }

    func addArrangedSubviews(_ views: UIView...) {
        views.forEach { addArrangedSubview($0) }
    }
}
