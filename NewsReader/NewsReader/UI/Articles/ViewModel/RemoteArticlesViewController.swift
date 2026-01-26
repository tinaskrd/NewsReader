//
//  RemoteArticlesViewController.swift
//  NewsReader
//

import Foundation
import Combine
import NewsService
import DataTypes

final class RemoteArticlesViewModel: BaseArticlesViewModel, ArticlesViewModel {

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
        icon: Asset.Icon.icRSS.image,
        buttonTitle: L10n.Button.reload,
        buttonAction: { [weak self] in
            self?.reloadData()
        }
    )

    private let apiService: NewsService
    private let source: NewsSource

    // MARK: - Init

    init(
        apiService: NewsService,
        source: NewsSource,
        router: Router,
        storageService: ArticlesStorageService
    )  {
        self.apiService = apiService
        self.source = source
        super.init(storageService: storageService, router: router)
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
}

// MARK: - Private

private extension RemoteArticlesViewModel {
    func fetchData() async {
        guard !isDataLoading else { return }
        defer { isDataLoading = false }

        isDataLoading = true

        do {
            let articles = try await apiService.fetchArticles(source: source)
            self.articles = articles.map {
                ArticleViewModel(
                    from: $0,
                    storageService: storageService,
                    router: router
                )
            }
        } catch {
            show(error: L10n.Error.Message.Feed.load)
            articles = []
        }
    }
}
