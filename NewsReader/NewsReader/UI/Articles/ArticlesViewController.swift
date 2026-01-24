//
//  ArticlesViewController.swift
//  NewsReader
//

import UIKit
import Combine
import EmptyDataSet_Swift

final class ArticlesViewController: UIViewController {

    private let viewModel: ArticlesViewModel!

    private let cellIdentifier = "ArticleCell"
    private let tableView = UITableView()

    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl.default()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
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
        if !viewModel.isDataLoading {
            refreshControl.endRefreshing()
        }
        tableView.reloadEmptyDataSet()
    }

    func setupUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        tableView.register(ArticleCell.self, forCellReuseIdentifier: cellIdentifier)

        tableView.dataSource = self
        tableView.delegate = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.refreshControl = refreshControl
    }
}

// MARK: - UITableViewDelegate

extension ArticlesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let article = viewModel.articles[indexPath.row]
        viewModel.open(article)
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let shareAction = UIContextualAction(style: .normal, title: L10n.Button.share) { [weak self] _, _, completion in
            guard let self else { return }

            let article = viewModel.articles[indexPath.row]
            let result = viewModel.share(article)

            completion(result)
        }

        shareAction.backgroundColor = .accent
        shareAction.image = UIImage(systemName: L10n.Image.share)

        let config = UISwipeActionsConfiguration(actions: [shareAction])
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ArticleCell else { return UITableViewCell() }
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
        -50.0
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
