//
//  FeedMenuCell.swift
//  NewsReader
//

import UIKit
import PagingKit
import SnapKit

final class FeedMenuCell: PagingMenuViewCell {
    static let reuseIdentifier = name

    let titleLabel = UILabel(
        font: .primaryMedium(of: 17.0),
        textColor: .title,
        textAlignment: .center
    )

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private

private extension FeedMenuCell {
    func setupUI() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(8.0)
            make.verticalEdges.equalToSuperview().inset(6.0)
        }
    }
}

