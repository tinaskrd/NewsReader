//
//  ArticlesViewModel.swift
//  NewsReader
//

import Foundation
import Combine

protocol ArticlesViewModel: AnyObject {
    var articles: [ArticleViewModel] { get }

    var onDataChangedPublisher: AnyPublisher<[ArticleViewModel], Never> { get }

    var isDataLoading: Bool { get }
    var onDataLoadingPublisher: AnyPublisher<Bool, Never> { get }

    var emptyViewModel: EmptyViewModel { get }

    func loadData()
    func reloadData()

    func open(_ article: ArticleViewModel)

    @discardableResult
    func toggleFavorite(_ article: ArticleViewModel) -> Bool
}
