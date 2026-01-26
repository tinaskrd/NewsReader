//
//  AppRouter.swift
//  NewsReader
//


import UIKit

// MARK: - Default Router

/**
 Default router implementation that can be used from view models / coordinators.
 Provide a presenter (usually the current view controller) and (optionally) a navigation controller.
 */
final class AppRouter {
    init() {
    }
}

// MARK: - Router

extension AppRouter: Router {
    var presentingViewController: UIViewController? {
        Self.topMostViewController(from: Self.rootViewController())
    }

    var navigationController: UINavigationController? {
        Self.currentNavigationController(from: presentingViewController)
    }

    func push(_ viewController: UIViewController, animated: Bool = true) {
        navigationController?.pushViewController(viewController, animated: animated)
    }

    func presentAlert(
        title: String?,
        message: String?,
        preferredStyle: UIAlertController.Style = .alert,
        actions: [UIAlertAction] = [],
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        guard let presenter = presentingViewController else { return }

        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)

        if actions.isEmpty {
            alert.addAction(UIAlertAction(title: L10n.Alert.Button.ok, style: .default))
        } else {
            actions.forEach { alert.addAction($0) }
        }

        presenter.present(alert, animated: animated, completion: completion)
    }

    func presentOKAlert(
        title: String?,
        message: String?,
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        presentAlert(
            title: title,
            message: message,
            preferredStyle: .alert,
            actions: [UIAlertAction(title: L10n.Alert.Button.ok, style: .default)],
            animated: animated,
            completion: completion
        )
    }

    func present(error: String, completion: (() -> Void)?) {
        presentOKAlert(
            title: L10n.Error.title,
            message: error,
            animated: true,
            completion: completion
        )
    }

    func share(
        items: [Any],
        excludedActivityTypes: [UIActivity.ActivityType]? = nil,
        sourceView: UIView? = nil,
        sourceRect: CGRect? = nil,
        barButtonItem: UIBarButtonItem? = nil,
        animated: Bool = true,
        completion: UIActivityViewController.CompletionWithItemsHandler? = nil
    ) {
        guard let presenter = presentingViewController else { return }
        
        let activity = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activity.excludedActivityTypes = excludedActivityTypes
        activity.completionWithItemsHandler = completion
        presenter.present(activity, animated: animated)
    }
}

// MARK: - Private helpers

private extension AppRouter {
    static func rootViewController() -> UIViewController? {
        // Prefer the currently active foreground scene.
        let windowScenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
        let activeScene = windowScenes.first(where: { $0.activationState == .foregroundActive })

        // If the project has `SceneDelegate`, try to read root from it.
        if let activeScene,
           let sceneDelegate = activeScene.delegate as? SceneDelegate,
           let root = sceneDelegate.window?.rootViewController {
            return root
        }

        // Fallback: key window root controller.
        if let activeScene,
           let root = activeScene.windows.first(where: { $0.isKeyWindow })?.rootViewController {
            return root
        }

        // Last resort: first available root.
        return windowScenes
            .flatMap { $0.windows }
            .first(where: { $0.isKeyWindow })?.rootViewController
        ?? windowScenes.first?.windows.first?.rootViewController
    }

    static func topMostViewController(from viewController: UIViewController?) -> UIViewController? {
        guard let viewController else { return nil }

        if let navigationController = viewController as? UINavigationController {
            return topMostViewController(from: navigationController.visibleViewController)
        }

        if let tabBarController = viewController as? UITabBarController {
            return topMostViewController(from: tabBarController.selectedViewController)
        }

        if let presented = viewController.presentedViewController {
            return topMostViewController(from: presented)
        }

        return viewController
    }

    static func currentNavigationController(from presenter: UIViewController?) -> UINavigationController? {
        if let navigationController = presenter as? UINavigationController {
            return navigationController
        }
        return presenter?.navigationController
    }
}
