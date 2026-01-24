//
//  ViewController.swift
//  NewsReader
//
//  Created by Tina  on 12.01.26.
//

import UIKit
import SnapKit
import NetworkClient

class ViewController: UIViewController{
   
    
    
    override func viewDidLoad() {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = Asset.share.image

        view.addSubview(imageView)

        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(50)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(100)
        }
    }


}

