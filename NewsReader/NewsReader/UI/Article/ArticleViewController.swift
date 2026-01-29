//
//  ArticleViewController.swift
//  NewsReader
//

import UIKit
import WebKit

final class ArticleViewController: UIViewController {

    private enum Constant {
        static let iconSize = CGSize(width: 28.0, height: 28.0)
    }

    private let webView = WKWebView()

    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .accent
        indicator.hidesWhenStopped = true
        return indicator
    }()

    private lazy var favoriteImage: UIImage? = {
        Asset.Icon.icFavorite.image.resized(to: Constant.iconSize)
    }()

    private lazy var unfavoriteImage: UIImage? = {
        Asset.Icon.icUnfavorite.image.resized(to: Constant.iconSize)
    }()

    private let viewModel: ArticleViewModel

    private var hasLoadedInitialRequest = false
    private var isInitialRequestInProgress = false

    // MARK: - Init

    init(viewModel: ArticleViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        load(viewModel)
    }
}

// MARK: - Private

private extension ArticleViewController {
    func setupUI() {
        view.addSubviews(webView, loadingIndicator)

        setupNavigationBarButtons()

        webView.navigationDelegate = self
        webView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    func setupNavigationBarButtons() {
        let shareButton = UIBarButtonItem(
            image: Asset.Icon.icShare.image.resized(to: Constant.iconSize),
            style: .plain,
            target: self,
            action: #selector(shareButtonTapped)
        )

        let favoriteButton = UIBarButtonItem(
            image: viewModel.isFavorite ? unfavoriteImage : favoriteImage,
            style: .plain,
            target: self,
            action: #selector(favoriteButtonTapped)
        )

        navigationItem.rightBarButtonItems = [favoriteButton, shareButton]
    }

    func load(_ article: ArticleViewModel) {
        guard let url = article.url else { return }

        beginInitialLoadIfNeeded()

        let request = URLRequest(url: url)
        webView.load(request)
    }

    func beginInitialLoadIfNeeded() {
        guard !hasLoadedInitialRequest else { return }
        isInitialRequestInProgress = true
        loadingIndicator.startAnimating()
    }

    func endInitialLoadIfNeeded(success: Bool) {
        guard isInitialRequestInProgress else { return }
        isInitialRequestInProgress = false
        loadingIndicator.stopAnimating()
        if success {
            hasLoadedInitialRequest = true
        }
    }
}

// MARK: - Actions

private extension ArticleViewController {
    @objc
    func shareButtonTapped() {
        viewModel.share()
    }

    @objc
    func favoriteButtonTapped() {
        viewModel.toggleFavorite()
        setupNavigationBarButtons()
    }
}

// MARK: - WKNavigationDelegate

extension ArticleViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        beginInitialLoadIfNeeded()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        endInitialLoadIfNeeded(success: true)
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        endInitialLoadIfNeeded(success: false)
    }

    func webView(
        _ webView: WKWebView,
        didFailProvisionalNavigation navigation: WKNavigation!,
        withError error: Error
    ) {
        endInitialLoadIfNeeded(success: false)
    }
}
