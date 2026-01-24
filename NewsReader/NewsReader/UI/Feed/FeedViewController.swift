//
//  FeedViewController.swift
//  NewsReader

import UIKit
import PagingKit

final class FeedViewController: UIViewController {
    private lazy var menuViewController = PagingMenuViewController()
    private lazy var contentViewController = PagingContentViewController()

    private let viewModel = FeedViewModel(newsService: AppDI.shared.newService)

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: - Private

private extension FeedViewController {
    func setupUI() {
        addSubviews()

        menuViewController.register(
            type: FeedMenuCell.self,
            forCellWithReuseIdentifier: FeedMenuCell.reuseIdentifier
        )
        menuViewController.registerFocusView(nib: UINib(nibName: "FeedUnderlineFocusView", bundle: nil))
        menuViewController.dataSource = self
        menuViewController.delegate = self
        menuViewController.cellAlignment = .center
        menuViewController.reloadData()

        contentViewController.dataSource = self
        contentViewController.delegate = self
        contentViewController.reloadData()
        
        title = L10n.Navigation.News.title
    }

    func addSubviews() {
        menuViewController.willMove(toParent: self)
        addChild(menuViewController)
        view.addSubview(menuViewController.view)
        menuViewController.view.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        menuViewController.didMove(toParent: self)


        contentViewController.willMove(toParent: self)
        view.addSubview(contentViewController.view)
        contentViewController.view.snp.makeConstraints { make in
            make.top.equalTo(menuViewController.view.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        contentViewController.didMove(toParent: self)
    }
}

// MARK: - PagingMenuViewControllerDataSource

extension FeedViewController: PagingMenuViewControllerDataSource {
    func numberOfItemsForMenuViewController(viewController: PagingMenuViewController) -> Int {
        viewModel.sources.count
    }

    func menuViewController(viewController: PagingMenuViewController, cellForItemAt index: Int) -> PagingMenuViewCell {
        guard
            let cell = viewController.dequeueReusableCell(
                withReuseIdentifier: FeedMenuCell.reuseIdentifier,
                for: index
            ) as? FeedMenuCell
        else {
            return FeedMenuCell()
        }
        let source = viewModel.sources[index]
        cell.titleLabel.text = source.name
        return cell
    }

    func menuViewController(viewController: PagingMenuViewController, widthForItemAt index: Int) -> CGFloat {
        let title = viewModel.sources[index].name
        let font = UIFont.primaryMedium(of: 17.0)

        // Add padding so the label isn't clipped inside the cell.
        let horizontalPadding: CGFloat = 24 // 12pt left + 12pt right
        let minTapWidth: CGFloat = 44

        let textWidth = (title as NSString).size(withAttributes: [.font: font]).width
        return max(minTapWidth, ceil(textWidth + horizontalPadding))
    }
}

// MARK: - PagingContentViewControllerDataSource

extension FeedViewController: PagingContentViewControllerDataSource {
    func numberOfItemsForContentViewController(viewController: PagingContentViewController) -> Int {
        viewModel.sources.count
    }

    func contentViewController(
        viewController: PagingContentViewController,
        viewControllerAt index: Int
    ) -> UIViewController {
        let source = viewModel.sources[index]
        let viewModel = ArticlesViewModel(apiService: AppDI.shared.newService, source: source)
        let viewController = ArticlesViewController(viewModel: viewModel, delegate: self)
        return viewController
    }
}

// MARK: - PagingMenuViewControllerDelegate

extension FeedViewController: PagingMenuViewControllerDelegate {
    func menuViewController(viewController: PagingMenuViewController, didSelect page: Int, previousPage: Int) {
        contentViewController.scroll(to: page, animated: true)
    }
}

// MARK: - PagingContentViewControllerDelegate

extension FeedViewController: PagingContentViewControllerDelegate {
    func contentViewController(
        viewController: PagingContentViewController,
        didManualScrollOn index: Int,
        percent: CGFloat
    ) {
        menuViewController.scroll(index: index, percent: percent, animated: false)
    }
}

// MARK: - ArticlesViewControllerDelegate

extension FeedViewController: ArticlesViewControllerDelegate {
    func articlesViewControllerDidSelect(_ controller: ArticlesViewController, didSelected article: Article) {
        let articleVC = ArticleViewController(article: article)
        navigationController?.pushViewController(articleVC, animated: true)
    }
}
