//
//  EmptyView.swift
//  NewsReader
//


import UIKit
import SnapKit

final class EmptyView: UIView {
    let viewModel: EmptyViewModel

    private let titleLabel = UILabel(
        font: .primarySemibold(of: 17.0),
        textColor: .titleColor,
        textAlignment: .center,
        numberOfLines: 0
    )

    private let messageLabel = UILabel(
        font: .primaryRegular(of: 15.0),
        textColor: .titleColor,
        textAlignment: .center,
        numberOfLines: 0
    )

    private let imageView = UIImageView(contentMode: .scaleAspectFit)

    private lazy var button: UIButton = {
        let button = UIButton(configuration: .plain())
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()

    private let stackView = UIStackView(
        axis: .vertical,
        spacing: 16.0
    )

    // MARK: - Lifecycle

    init(viewModel: EmptyViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupUI()
        updateData()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private

private extension EmptyView {
    func updateData() {
        titleLabel.text = viewModel.title

        messageLabel.text = viewModel.message
        messageLabel.isHidden = (viewModel.message ?? "").isEmpty

        imageView.image = viewModel.icon
        imageView.isHidden = viewModel.icon == nil

        button.configuration?.title = viewModel.buttonTitle
        button.isHidden = viewModel.buttonAction == nil
    }

    func setupUI() {
        addSubviews()
        addConstraints()
    }

    func addSubviews() {
        addSubview(stackView)
        stackView.addArrangedSubviews(
            titleLabel,
            imageView,
            messageLabel,
            button
        )
    }

    func addConstraints() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20.0)
        }

        imageView.snp.makeConstraints { make in
            make.height.equalTo(100.0)
        }

        button.snp.makeConstraints { make in
            make.height.equalTo(40.0)
        }
    }
}

// MARK: - Actions

private extension EmptyView {
    @objc
    func buttonTapped() {
        viewModel.buttonAction?()
    }
}
