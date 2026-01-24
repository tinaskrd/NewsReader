//
//  ArticlesViewModel.swift
//  NewsReader
//

import Foundation
import Combine
import NewsService
import DataTypes

final class ArticlesViewModel {

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
        title: L10n.Screen.Articles.Empty.title,
        message: L10n.Screen.Articles.Empty.message,
        icon: Asset.icRSS.image,
        buttonTitle: L10n.Button.reload,
        buttonAction: { [weak self] in
            self?.reloadData()
        }
    )

    private let apiService: NewsService
    private let source: NewsSource
    private let router: Router

    // MARK: - Init

    init(apiService: NewsService, source: NewsSource, router: Router)  {
        self.apiService = apiService
        self.source = source
        self.router = router
    }

    // MARK: - Public

    func loadData() {
        Task { [weak self] in
            await self?.fetchData()
        }
    }

    func reloadData() {
        loadData()
    }

    func open(_ article: ArticleViewModel) {
        let articleVC = ArticleViewController(article: article)
        router.push(articleVC)
    }

    @discardableResult
    func share(_ article: ArticleViewModel) -> Bool {
        guard let url = article.url else { return false }
        router.share(items: [url])
        return true
    }
}

// MARK: - Private

private extension ArticlesViewModel {
    func fetchData() async {
        guard !isDataLoading else { return }
        defer { isDataLoading = false }

        isDataLoading = true

        do {
            let articles = try await apiService.fetchArticles(source: source)
            self.articles = articles.map(ArticleViewModel.init)
        } catch {
            print(error)
            // TODO: show error to user
            articles = []
        }
    }
}
