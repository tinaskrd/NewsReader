import DataTypes

public protocol NewsService {
    var categories: [NewsCategory] { get }
    var sources: [NewsSource] { get }
    var countries: [Country] { get }

    func fetchArticles(source: NewsSource) async throws -> [Article]
}
