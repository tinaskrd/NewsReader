

import Foundation
import DataTypes

enum NewsAPISource: CaseIterable {
    case bbcNews
    case cnn
    case foxNews
    case googleNews
}

extension NewsAPISource: NewsSource {
    var name: String {
        switch self {
        case .bbcNews:
            return "BBC News"
        case .cnn:
            return "CNN"
        case .foxNews:
            return "Fox News"
        case .googleNews:
            return "Google News"
        }
    }
    
    var id: String {
        switch self {
        case .bbcNews:
            return "bbc-news"
        case .cnn:
            return "cnn"
        case .foxNews:
            return "fox-news"
        case .googleNews:
            return "google-news"
        }
    }
}
