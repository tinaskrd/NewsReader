//
//  ArticlesViewModel.swift
//  NewsReader
//


import Foundation
import Combine
import NewsService
import DataTypes

final class ArticlesViewModel {

    private(set) var articles: [Article] = [] {
        didSet {
            guard oldValue != articles else { return }
            onDataChangedSubject.send(articles)
        }
    }

    var onDataChangedPublisher: AnyPublisher<[Article], Never> {
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
    private let onDataChangedSubject = PassthroughSubject<[Article], Never>()

    private(set) lazy var emptyViewModel = EmptyViewModel(
        title: L10n.Articles.Empty.title,
        message: L10n.Articles.Empty.message,
        icon: Asset.icRSS.image,
        buttonTitle: L10n.Button.reload,
        buttonAction: { [weak self] in
            self?.reloadData()
        }
    )

    private let apiService: NewsService
    private let source: NewsSource

    // MARK: - Init

    init(apiService: NewsService, source: NewsSource)  {
        self.apiService = apiService
        self.source = source
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

private extension ArticlesViewModel {
    func fetchData() async {
        guard !isDataLoading else { return }
        defer { isDataLoading = false }

        isDataLoading = true

        do {
            let articles = try await apiService.fetchArticles(source: source)
            self.articles = articles.map(Article.init)
        } catch {
            print(error)
            // TODO: show error to user
            articles = []
        }
    }
}
