//
//  ViewController.swift
//  NewsReader
//

import UIKit
import SnapKit
import NewsService

class ViewController: UIViewController {
    private let newsService: NewsService = AppDI.shared.newService


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = Asset.share.image

        view.addSubview(imageView)

        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(50)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(100)
        }

        Task { [weak self] in
            guard
                let self,
                let source = newsService.sources.first
            else { return }

            do {
                let articles = try await newsService.fetchArticles(source: source)
                print(articles)
            } catch {
                print(error)
            }
        }
    }
}
