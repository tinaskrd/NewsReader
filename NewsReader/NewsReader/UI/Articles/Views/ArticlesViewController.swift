//
//  ArticlesViewController.swift
//  NewsReader
//

import UIKit
import Combine
import EmptyDataSet_Swift

final class ArticlesViewController: UIViewController {

    private enum Constant {
        static let actionIconSize = CGSize(width: 32.0, height: 32.0)
    }

    private let viewModel: ArticlesViewModel

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ArticleCell.self, forCellReuseIdentifier: ArticleCell.reuseIdentifier)

        tableView.dataSource = self
        tableView.delegate = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.refreshControl = refreshControl
        return tableView
    }()

    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl.default()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()

    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .accent
        indicator.hidesWhenStopped = true
        return indicator
    }()

    private lazy var favoriteImage: UIImage? = {
        Asset.Icon.icFavorite.image.resized(to: Constant.actionIconSize)
    }()

    private lazy var unfavoriteImage: UIImage? = {
        Asset.Icon.icUnfavorite.image.resized(to: Constant.actionIconSize)
    }()

    private lazy var shareImage: UIImage? = {
        Asset.Icon.icShare.image
            .resized(to: Constant.actionIconSize)?
            .withTintColor(.appBackground)
    }()

    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Init

    init(viewModel: ArticlesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
        viewModel.loadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.reloadData()
    }
}

// MARK: - Private

private extension ArticlesViewController {
    func bind() {
        viewModel.onDataLoadingPublisher
            .dispatchOnMainQueue()
            .sink { [weak self] _ in
                self?.refreshLoadingState()
            }
            .store(in: &cancellables)

        viewModel.onDataChangedPublisher
            .dispatchOnMainQueue()
            .sink { [weak self] _ in
                self?.reloadData()
            }
            .store(in: &cancellables)
    }

    func reloadData() {
        tableView.reloadData()
    }

    func refreshLoadingState() {
        if viewModel.isDataLoading && viewModel.articles.isEmpty {
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
            refreshControl.endRefreshing()
        }

        tableView.reloadEmptyDataSet()
    }

    func setupUI() {
        view.addSubviews(tableView, loadingIndicator)

        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        loadingIndicator.snp.makeConstraints { make in
            make.centerX.equalTo(tableView.snp.centerX)
            make.centerY.equalTo(tableView.snp.centerY).offset(-100.0)
        }
    }
}

// MARK: - UITableViewDelegate

extension ArticlesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let article = viewModel.articles[indexPath.row]
        viewModel.open(article)
    }

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let article = viewModel.articles[indexPath.row]

        // Favorite/Unfavorite Action
        let isFavorite = article.isFavorite
        let favoriteAction = UIContextualAction(
            style: .normal,
            title: isFavorite ? L10n.Button.unfavorite : L10n.Button.favorite
        ) { [weak self] _, _, completion in
            guard let self else { return }

            let result = viewModel.toggleFavorite(article)
            completion(result)
        }

        favoriteAction.backgroundColor = .appYellow
        favoriteAction.image = (isFavorite ? unfavoriteImage : favoriteImage)?
            .withTintColor(.appBackground)

        // Share action
        let shareAction = UIContextualAction(style: .normal, title: L10n.Button.share) { [weak self] _, _, completion in
            guard let self else { return }

            let result = viewModel.articles[indexPath.row].share()
            completion(result)
        }

        shareAction.backgroundColor = .accent
        shareAction.image = shareImage

        let config = UISwipeActionsConfiguration(actions: [favoriteAction, shareAction])
        config.performsFirstActionWithFullSwipe = true
        return config
    }
}

// MARK: - UITableViewDataSource

extension ArticlesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.articles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ArticleCell.reuseIdentifier,
                for: indexPath
            ) as? ArticleCell
        else { return UITableViewCell() }
        cell.update(with: viewModel.articles[indexPath.row])
        return cell
    }
}

// MARK: - EmptyDataSetSource

extension ArticlesViewController: EmptyDataSetSource {
    func customView(forEmptyDataSet scrollView: UIScrollView) -> UIView? {
        EmptyView(viewModel: viewModel.emptyViewModel)
    }

    func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        -100.0
    }
}

// MARK: - EmptyDataSetDelegate

extension ArticlesViewController: EmptyDataSetDelegate {
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
        true
    }

    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        !viewModel.isDataLoading
    }
}

// MARK: - Actions

private extension ArticlesViewController {
    @objc
    func refresh() {
        viewModel.reloadData()
    }
}
