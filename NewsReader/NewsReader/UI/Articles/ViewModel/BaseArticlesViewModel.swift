//
//  BaseArticlesViewModel.swift
//  NewsReader
//

import Foundation

class BaseArticlesViewModel {
    let router: Router
    let storageService: ArticlesStorageService

    // MARK: - Init

    init(storageService: ArticlesStorageService, router: Router) {
        self.storageService = storageService
        self.router = router
    }

    // MARK: - Public

    func open(_ article: ArticleViewModel) {
        let articleVC = ArticleViewController(viewModel: article)
        Task { @MainActor [weak self] in
            self?.router.push(articleVC)
        }
    }

    @discardableResult
    func toggleFavorite(_ article: ArticleViewModel) -> Bool {
        article.toggleFavorite()
    }

    func show(error: String) {
        Task { @MainActor [weak self] in
            self?.router.present(error: error)
        }
    }
}
