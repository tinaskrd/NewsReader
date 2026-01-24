//
//  Article.swift
//  DataTypes
//

import Foundation

public struct Article: Equatable, Identifiable {
    public let id: String
    public let sourceName: String
    public let author: String?
    public let title: String
    public let description: String?
    public let url: URL
    public let imageURL: URL?
    public let publishedAt: Date
    public let content: String?

    public init(
        id: String,
        sourceName: String,
        author: String?,
        title: String,
        description: String?,
        url: URL,
        imageURL: URL?,
        publishedAt: Date,
        content: String?
    ) {
        self.id = id
        self.sourceName = sourceName
        self.author = author
        self.title = title
        self.description = description
        self.url = url
        self.imageURL = imageURL
        self.publishedAt = publishedAt
        self.content = content
    }
}
