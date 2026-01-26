//
//  ArticleCell.swift
//  NewsReader
//

import UIKit
import Kingfisher

final class ArticleCell: UITableViewCell {
    
    static let reuseIdentifier = "ArticleCell"
    
    private let titleLabel = UILabel(
        font: .primarySemibold(of: 16.0),
        textColor: .title,
        textAlignment: .left,
        numberOfLines: 2
    )
    
    private let summaryLabel =  UILabel(
        font: .primarySemibold(of: 14.0),
        textColor: .title,
        textAlignment: .left,
        numberOfLines: 3
    )
    
    private let dateLabel = UILabel(
        font: .primaryMedium(of: 12.0),
        textColor: .title,
        textAlignment: .left
    )
    
    private let articleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.roundCorners(8)
        return imageView
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init (coder: ) has not been implemented")
    }

    // MARK: - Lifecycle

    override func prepareForReuse() {
        super.prepareForReuse()
        articleImageView.kf.cancelDownloadTask()
    }
}

// MARK: - Private

extension ArticleCell {
    private func setupUI() {

        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = .appYellow.withAlphaComponent(0.3)
        self.selectedBackgroundView = selectedBackgroundView

        contentView.addSubviews(
            articleImageView,
            titleLabel,
            summaryLabel,
            dateLabel
        )

        articleImageView.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(12)
            make.bottom.lessThanOrEqualToSuperview().offset(-12)
            make.width.equalTo(80)
            make.height.equalTo(110)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(articleImageView)
            make.left.equalTo(articleImageView.snp.right).offset(12)
            make.right.equalToSuperview().offset(-12)
        }
        
        summaryLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.left.right.equalTo(titleLabel)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(summaryLabel.snp.bottom).offset(6)
            make.left.equalTo(titleLabel)
            make.bottom.lessThanOrEqualToSuperview().offset(-12)
        }
    }
}

// MARK: - Public

extension ArticleCell {
    func update(with viewModel: ArticleViewModel) {
        titleLabel.text = viewModel.title
        summaryLabel.text = viewModel.summary
        dateLabel.text = viewModel.publishedDate
        articleImageView.kf.indicatorType = .activity
        articleImageView.kf.setImage(
            with: viewModel.imageURL,
            options: [.transition(.fade(0.25))]
        ) { [weak self] result in
            guard let self else { return }
            if case .failure = result {
                articleImageView.image = Asset.Image.imgPhoto.image
            }
        }
    }
}
