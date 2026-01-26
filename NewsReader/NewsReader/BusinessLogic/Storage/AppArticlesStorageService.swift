//
//  AppArticlesStorageService.swift
//  NewsReader
//

import Foundation
import SwiftData
import DataTypes

enum AppArticlesStorageServiceError: Error {
    case notFound(id: String)
}

final class AppArticlesStorageService {

    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }
}

// MARK: - ArticlesStorageService

extension AppArticlesStorageService: ArticlesStorageService {
    func store(_ article: Article) throws {
        if let existing = try fetchModel(id: article.id) {
            existing.update(from: article)
        } else {
            context.insert(ArticleEntity(article: article))
        }
        try context.save()
    }

    func fetchAll(sortedByDateDescending: Bool = true) throws -> [Article] {
        var descriptor = FetchDescriptor<ArticleEntity>()
        let order: SortOrder = sortedByDateDescending ? .reverse : .forward
        descriptor.sortBy = [SortDescriptor(\ArticleEntity.publishedAt, order: order)]
        return try context.fetch(descriptor).map { $0.mapToArticle() }
    }

    func fetch(id: String) throws -> Article? {
        try fetchModel(id: id)?.mapToArticle()
    }

    func delete(id: String) throws {
        guard let model = try fetchModel(id: id) else {
            throw AppArticlesStorageServiceError.notFound(id: id)
        }
        context.delete(model)
        try context.save()
    }

    func deleteAll() throws {
        try context.delete(model: ArticleEntity.self)
        try context.save()
    }
}

// MARK: - Private

private extension AppArticlesStorageService {
    func fetchModel(id: String) throws -> ArticleEntity? {
        var descriptor = FetchDescriptor<ArticleEntity>(
            predicate: #Predicate { $0.id == id }
        )
        descriptor.fetchLimit = 1
        return try context.fetch(descriptor).first
    }
}
