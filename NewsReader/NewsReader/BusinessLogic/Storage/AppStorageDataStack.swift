//
//  AppStorageDataStack.swift
//  NewsReader
//

import Foundation
import SwiftData

final class AppStorageDataStack {
    static let shared = AppStorageDataStack()
    
    let container: ModelContainer
    let mainContext: ModelContext
    
    private init() {
        do {
            container = try ModelContainer(for: ArticleEntity.self)
        } catch {
            fatalError("Failed to create SwiftData ModelContainer: \(error)")
        }
        
        mainContext = ModelContext(container)
    }
}

extension ModelContext {
    /// App-wide main context for SwiftData storage.
    static var main: ModelContext {
        AppStorageDataStack.shared.mainContext
    }
}
