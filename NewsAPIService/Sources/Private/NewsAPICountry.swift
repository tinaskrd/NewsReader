//
//  NewsAPICountry.swift
//  NewsAPIService
//

import Foundation
import DataTypes

enum NewsAPICountry: CaseIterable {
    case india
    case usa
    case australia
    case russia
    case france
    case uk
}

extension NewsAPICountry: Country {
    var name: String {
        switch self {
        case .india:
            return "India"
        case .usa:
            return "USA"
        case .australia:
            return "Australia"
        case .russia:
            return "Russia"
        case .france:
            return "France"
        case .uk:
            return    "United Kingdom"
        }
    }
    
    var isoCode: String {
        switch self {
        case .india:
            return "in"
        case .usa:
            return "us"
        case .australia:
            return "au"
        case .russia:
            return "ru"
        case .france:
            return "fr"
        case .uk:
            return "gb"
        }
    }
}
