//
//  AppDI.swift
//  NewsReader


import Foundation
import NetworkClient
import AlamofireNetworkClient
import NewsService
import NewsAPIService

final class AppDI {
    static let shared = AppDI()

    private lazy var networkClient: NetworkClient = {
        AlamofireNetworkClient()
    }()

    private(set) lazy var newService: NewsService = {
        NewsAPIService(baseURL: AppConstants.newURL, networkClient: networkClient)
    }()

    private(set) lazy var router: Router = AppRouter()

    private init() {
    }
}
