//
//  UIFont+Utils.swift
//  NewsReader
//


import UIKit

extension UIFont {
    static func primaryRegular(of size: CGFloat) -> UIFont {
        .systemFont(ofSize: size, weight: .regular)
    }

    static func primaryMedium(of size: CGFloat) -> UIFont {
        .systemFont(ofSize: size, weight: .medium)
    }

    static func primarySemibold(of size: CGFloat) -> UIFont {
        .systemFont(ofSize: size, weight: .semibold)
    }

}

