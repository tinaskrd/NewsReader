//
//  ArticleEntity.swift
//  NewsReader
//

import Foundation
import SwiftData
import DataTypes

@Model
final class ArticleEntity {
    @Attribute(.unique)
    var id: String

    var sourceName: String
    var author: String?
    var title: String
    var articleDescription: String?
    var url: URL
    var imageURL: URL?
    var publishedAt: Date
    var content: String?

    init(
        id: String,
        sourceName: String,
        author: String?,
        title: String,
        articleDescription: String?,
        url: URL,
        imageURL: URL?,
        publishedAt: Date,
        content: String?
    ) {
        self.id = id
        self.sourceName = sourceName
        self.author = author
        self.title = title
        self.articleDescription = articleDescription
        self.url = url
        self.imageURL = imageURL
        self.publishedAt = publishedAt
        self.content = content
    }

    convenience init(article: Article) {
        self.init(
            id: article.id,
            sourceName: article.sourceName,
            author: article.author,
            title: article.title,
            articleDescription: article.description,
            url: article.url,
            imageURL: article.imageURL,
            publishedAt: article.publishedAt,
            content: article.content
        )
    }

    func update(from article: Article) {
        id = article.id
        sourceName = article.sourceName
        author = article.author
        title = article.title
        articleDescription = article.description
        url = article.url
        imageURL = article.imageURL
        publishedAt = article.publishedAt
        content = article.content
    }
}

extension ArticleEntity {
    func mapToArticle() -> Article {
        Article(
            id: id,
            sourceName: sourceName,
            author: author,
            title: title,
            description: articleDescription,
            url: url,
            imageURL: imageURL,
            publishedAt: publishedAt,
            content: content
        )
    }
}
