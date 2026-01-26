//
//  ArticleDTO.swift
//  NewsAPIService
//

import Foundation

struct ArticleDTO: Decodable {
    let source: SourceDTO
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: Date
    let content: String?
}
