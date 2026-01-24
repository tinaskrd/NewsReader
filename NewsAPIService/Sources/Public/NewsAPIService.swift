import Foundation
import NewsService
import NetworkClient
import DataTypes

public final class NewsAPIService {
    private let baseURL: URL
    private let networkClient: NetworkClient

    public init(baseURL: URL, networkClient: NetworkClient) {
        self.baseURL = baseURL
        self.networkClient = networkClient
    }
}

// MARK: - NewsService

extension NewsAPIService: NewsService {
    public var categories: [NewsCategory] {
        NewsAPICategory.allCases
    }

    public var sources: [NewsSource] {
        NewsAPISource.allCases
    }

    public var countries: [Country] {
        NewsAPICountry.allCases
    }

    public func fetchArticles(source: NewsSource) async throws -> [Article] {
        let path = "\(baseURL)/everything/\(source.id).json"
        guard let url = URL(string: path) else {
            throw NewsServiceError.service
        }
        do {
            let response = try await networkClient.getDecodable(url, as: NewsResponseDTO.self)
            let articles = try response.articles.map { try ArticleMapper.map($0) }
            return articles
        } catch {
            throw error
        }
    }
}
