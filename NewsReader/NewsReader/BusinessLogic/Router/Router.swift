//
//  Router.swift
//  NewsReader
//


import UIKit

protocol Router: AnyObject {

    /// View controller used to present alerts, share sheets, etc.
    var presentingViewController: UIViewController? { get }

    /// Navigation controller used for push-based navigation.
    var navigationController: UINavigationController? { get }

    // MARK: - Navigation

    func push(_ viewController: UIViewController, animated: Bool)

    // MARK: - Alerts

    func presentAlert(
        title: String?,
        message: String?,
        preferredStyle: UIAlertController.Style,
        actions: [UIAlertAction],
        animated: Bool,
        completion: (() -> Void)?
    )

    /// Convenience: simple OK alert.
    func presentOKAlert(
        title: String?,
        message: String?,
        animated: Bool,
        completion: (() -> Void)?
    )

    // MARK: - Share

    func share(
        items: [Any],
        excludedActivityTypes: [UIActivity.ActivityType]?,
        sourceView: UIView?,
        sourceRect: CGRect?,
        barButtonItem: UIBarButtonItem?,
        animated: Bool,
        completion: UIActivityViewController.CompletionWithItemsHandler?
    )
}

extension Router {
    func push(_ viewController: UIViewController) {
        push(viewController, animated: true)
    }

    func share(items: [Any]) {
        share(
            items: items,
            excludedActivityTypes: nil,
            sourceView: nil,
            sourceRect: nil,
            barButtonItem: nil,
            animated: true,
            completion: nil
        )
    }
}

