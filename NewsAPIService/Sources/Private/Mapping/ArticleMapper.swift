//
//  ArticleMapper.swift
//  NewsAPIService
//


import Foundation
import DataTypes

enum ArticleMapper {
    static func map(_ dto: ArticleDTO) throws -> Article {
        guard let url = URL(string: dto.url) else {
            throw NewsError.invalidData
        }

        return Article(
            id: dto.url,
            sourceName: dto.source.name,
            author: dto.author,
            title: dto.title,
            description: dto.description,
            url: url,
            imageURL: dto.urlToImage.flatMap(URL.init(string:)),
            publishedAt: dto.publishedAt,
            content: dto.content
        )
    }
}
