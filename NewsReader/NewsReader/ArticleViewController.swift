//
//  ArticleViewController.swift
//  NewsReader
//

import UIKit
import WebKit

final class ArticleViewController: UIViewController {

    private let webView = WKWebView()
    private let article: Article
    
    // MARK: - Init
    
    init(article: Article) {
        self.article = article
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadPage(with: article)
    }
}

// MARK: - Private

private extension ArticleViewController {
    func setupUI() {
        view.addSubviews(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func loadPage(with article: Article) {
        guard let url = article.url else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
