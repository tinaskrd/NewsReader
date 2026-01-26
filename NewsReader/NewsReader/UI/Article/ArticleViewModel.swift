//
//  Article.swift
//  NewsReader
//

import Foundation
import DataTypes

final class ArticleViewModel {
    let id: String
    let title: String
    let source: String
    let summary: String
    let imageURL: URL?
    let publishedAT: Date
    let content: String?
    let url: URL?

    var isFavorite: Bool {
        let stored = try? storageService.fetch(id: id)
        return stored != nil
    }

    var publishedDate: String {
        DateFormatter.pubDateFormatter.string(from: publishedAT)
    }

    private let storageService: ArticlesStorageService
    private let router: Router

    init(
        id: String,
        title: String,
        source: String,
        summary: String,
        imageURL: URL?,
        publishedAT: Date,
        content: String?,
        url: URL?,
        storageService: ArticlesStorageService,
        router: Router
    ) {
        self.id = id
        self.title = title
        self.source = source
        self.summary = summary
        self.imageURL = imageURL
        self.publishedAT = publishedAT
        self.content = content
        self.url = url
        self.storageService = storageService
        self.router = router
    }

    @discardableResult
    func share() -> Bool {
        guard let url else { return false }
        Task { @MainActor [weak self] in
            self?.router.share(items: [L10n.Share.message, url])
        }
        return true
    }

    @discardableResult
    func toggleFavorite() -> Bool {
        if isFavorite {
            return removeFromFavorites()
        } else {
            return addToFavorites()
        }
    }
}

// MARK: - Equatable

extension ArticleViewModel: Equatable {
    static func == (lhs: ArticleViewModel, rhs: ArticleViewModel) -> Bool {
        lhs.id == rhs.id &&
        lhs.title == rhs.title &&
        lhs.source == rhs.source &&
        lhs.summary == rhs.summary &&
        lhs.imageURL == rhs.imageURL &&
        lhs.publishedAT == rhs.publishedAT &&
        lhs.content == rhs.content &&
        lhs.url == rhs.url &&
        lhs.isFavorite == rhs.isFavorite
    }
}

// MARK: - Utils

extension ArticleViewModel {
    convenience init(
        from article: Article,
        storageService: ArticlesStorageService,
        router: Router
    ) {
        self.init(
            id: article.id,
            title: article.title,
            source: article.sourceName,
            summary: article.description ?? "",
            imageURL: article.imageURL,
            publishedAT: article.publishedAt,
            content: article.content,
            url: article.url,
            storageService: storageService,
            router: router
        )
    }

    /**
     Maps ViewModel -> Domain `Article`.
     Returns `nil` if `url` is missing (since `Article.url` is non-optional).
     */
    func mapToArticle() -> Article? {
        guard let url else { return nil }
        return Article(
            id: id,
            sourceName: source,
            author: nil, // TODO: add auth to UI and ViewModel
            title: title,
            description: summary,
            url: url,
            imageURL: imageURL,
            publishedAt: publishedAT,
            content: content
        )
    }
}

// MARK: - Private

private extension ArticleViewModel {
    @discardableResult
    func addToFavorites() -> Bool {
        guard let article = mapToArticle() else { return false }
        do {
            try storageService.store(article)
            return true
        } catch {
            show(error: L10n.Error.Message.favorite)
            return false
        }
    }

    @discardableResult
    func removeFromFavorites() -> Bool {
        do {
            try storageService.delete(id: id)
            return true
        } catch {
            show(error: L10n.Error.Message.unfavorite)
            return false
        }
    }

    func show(error: String) {
        Task { @MainActor [weak self] in
            self?.router.present(error: error)
        }
    }
}

extension DateFormatter {
    static let pubDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateStyle = .medium
        return formatter
    }()
}
