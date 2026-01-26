//
//  NewsResponseDTO.swift
//  NewsAPIService
//

import Foundation

struct NewsResponseDTO: Decodable {
    let status: String
    let totalResults: Int
    let articles: [ArticleDTO]
}
