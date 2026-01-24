//
//  FeedViewModel.swift
//  NewsReader
//

import Foundation
import DataTypes
import NewsService

final class FeedViewModel {
    private let newsService: NewsService

    private(set) var sources: [NewsSource] = []

    init(newsService: NewsService) {
        self.newsService = newsService
        self.sources = newsService.sources
    }
}
