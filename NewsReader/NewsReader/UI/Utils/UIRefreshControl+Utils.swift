//
//  UIRefreshControl+Utils.swift
//  NewsReader
//


import UIKit

public extension UIRefreshControl {
    static func `default`() -> UIRefreshControl {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .tintColor
        return refreshControl
    }
}
