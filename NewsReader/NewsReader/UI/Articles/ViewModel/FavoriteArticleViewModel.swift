//
//  FavoriteArticleViewModel.swift
//  NewsReader
//

import Foundation
import Combine

final class FavoriteArticlesViewModel: BaseArticlesViewModel, ArticlesViewModel {
    private(set) var articles: [ArticleViewModel] = [] {
        didSet {
            guard oldValue != articles else { return }
            onDataChangedSubject.send(articles)
        }
    }

    var onDataChangedPublisher: AnyPublisher<[ArticleViewModel], Never> {
        onDataChangedSubject.eraseToAnyPublisher()
    }

    private(set) var isDataLoading: Bool = false {
        didSet {
            guard oldValue != isDataLoading else { return }
            onDataLoadingSubject.send(isDataLoading)
        }
    }

    var onDataLoadingPublisher: AnyPublisher<Bool, Never> {
        onDataLoadingSubject.eraseToAnyPublisher()
    }

    private let onDataLoadingSubject = PassthroughSubject<Bool, Never>()
    private let onDataChangedSubject = PassthroughSubject<[ArticleViewModel], Never>()

    private(set) lazy var emptyViewModel = EmptyViewModel(
        title: L10n.Screen.Favorites.Empty.title,
        message: L10n.Screen.Favorites.Empty.message,
        icon: Asset.Icon.icRSS.image,
        buttonTitle: L10n.Button.reload,
        buttonAction: { [weak self] in
            self?.reloadData()
        }
    )

    func loadData() {
        Task { [weak self] in
            await self?.fetchData()
        }
    }

    func reloadData() {
        loadData()
    }

    override func toggleFavorite(_ article: ArticleViewModel) -> Bool {
        let result = super.toggleFavorite(article)
        if result {
            reloadData()
        }
        return result
    }
}

// MARK: - Private

private extension FavoriteArticlesViewModel {
    func fetchData() async {
        guard !isDataLoading else { return }
        defer { isDataLoading = false }

        isDataLoading = true

        do {
            let articles = try storageService.fetchAll(sortedByDateDescending: false)
            self.articles = articles.map {
                ArticleViewModel(
                    from: $0,
                    storageService: storageService,
                    router: router
                )
            }
        } catch {
            show(error: L10n.Error.Message.unknown)
            articles = []
        }
    }
}
