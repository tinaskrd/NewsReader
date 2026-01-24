
import Foundation
import DataTypes

enum NewsAPICategory: String, CaseIterable {
    case business
    case entertainment
    case general
    case health
    case science
    case sports
    case technology
}

// MARK: - NewsCategory

extension NewsAPICategory: NewsCategory {
    var name: String {
        rawValue
    }
}

