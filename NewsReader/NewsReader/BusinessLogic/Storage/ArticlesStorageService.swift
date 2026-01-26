//
//  ArticlesStorageService.swift
//  NewsReader

import Foundation
import DataTypes

protocol ArticlesStorageService {
    func store(_ article: Article) throws
    
    func fetchAll(sortedByDateDescending: Bool) throws -> [Article]
    func fetch(id: String) throws -> Article?
    
    func delete(id: String) throws
    func deleteAll() throws
}

