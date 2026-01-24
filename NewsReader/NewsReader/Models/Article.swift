//
//  Article.swift
//  NewsReader
//

import Foundation
import DataTypes

struct Article: Equatable {
    let id: String
    let title: String
    let source: String
    let summary: String
    let imageURL: URL?
    let publishedAT: Date
    let content: String?
    let url: URL?
}

extension Article {
    init(from article: DataTypes.Article) {
        self.id = article.id
        self.title = article.title
        self.source = article.sourceName
        self.summary = article.description ?? ""
        self.imageURL = article.imageURL
        self.publishedAT = article.publishedAt
        self.content = article.content
        self.url = article.url
    }
}

extension DateFormatter {
    static let article: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateStyle = .medium
        return formatter
    }()
}

extension Article {
    var publishedDateString: String {
        DateFormatter.article.string(from: publishedAT)
    }
}

