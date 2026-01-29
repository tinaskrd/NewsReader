//
//  TabBarController.swift
//  NewsReader
//

import UIKit

final class TabBarController: UITabBarController {

    private enum Constant {
        static let iconSize = CGSize(width: 25.0, height: 25.0)
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        configureAppearance()
    }
}

// MARK: - Private

private extension TabBarController {

    func setupTabs() {
        viewControllers = [
            createFeedTab(),
            createFavoritesTab()
        ]
    }

    func createFeedTab() -> UINavigationController {
        let feedVC = FeedViewController()
        let navigationController = createNavigationController(
            rootViewController: feedVC,
            title: L10n.Screen.Feed.title,
            icon: Asset.Icon.icFeed.image.resized(to: Constant.iconSize),
            selectedIcon: Asset.Icon.icFeed.image.resized(to: Constant.iconSize)
        )
        return navigationController
    }

    func createFavoritesTab() -> UINavigationController {
        let favoritesVM = FavoriteArticlesViewModel(
            storageService: AppDI.shared.storageService,
            router: AppDI.shared.router
        )
        let favoritesVC = ArticlesViewController(viewModel: favoritesVM)
        let navigationController = createNavigationController(
            rootViewController: favoritesVC,
            title: L10n.Screen.Favorites.title,
            icon: Asset.Icon.icFavorite.image.resized(to: Constant.iconSize),
            selectedIcon: Asset.Icon.icUnfavorite.image.resized(to: Constant.iconSize)
        )
        return navigationController
    }

    func createNavigationController(
        rootViewController: UIViewController,
        title: String,
        icon: UIImage?,
        selectedIcon: UIImage?
    ) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.tabBarItem = UITabBarItem(
            title: title,
            image: icon,
            selectedImage: selectedIcon
        )

        navigationController.navigationBar.prefersLargeTitles = false
        rootViewController.navigationItem.title = title

        return navigationController
    }

    func configureAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = .appBackground

        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
}
