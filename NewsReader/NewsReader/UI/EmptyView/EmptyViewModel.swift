//
//  EmptyViewModel.swift
//  NewsReader
//

import UIKit

struct EmptyViewModel {
    let title: String
    let message: String?
    let icon: UIImage?
    let buttonTitle: String?
    let buttonAction: (() -> Void)?

    init(
        title: String,
        message: String? = nil,
        icon: UIImage? = nil,
        buttonTitle: String? = nil,
        buttonAction: (() -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.icon = icon
        self.buttonTitle = buttonTitle
        self.buttonAction = buttonAction
    }
}
