//
//  SocialImageButton.swift
//  GiphyAppTestTask
//
//  Created by Stefan Boblic on 21.04.2023.
//

import UIKit
import SnapKit

class SocialImageButton: UIImageView {

    let buttonLayer = UIButton()

    var social: Social! = nil

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        self.buttonLayer.target(forAction: #selector(shareGIF), withSender: self)
        self.addSubview(buttonLayer)

        buttonLayer.snp.makeConstraints { make in
            make.left.right.top.bottom.equalTo(0)
        }
    }

    public func setupSocialButton(for social: Social) {
        switch social {
        case .IMessage:
            self.image = UIImage(named: "IMessage")
        case .Messenger:
            self.image = UIImage(named: "Messenger")
        case .Snapchat:
            self.image = UIImage(named: "Snapchat")
        case .WhatsApp:
            self.image = UIImage(named: "WhatsApp")
        case .Instagram:
            self.image = UIImage(named: "Instagram")
        case .Facebook:
            self.image = UIImage(named: "Facebook")
        case .Twitter:
            self.image = UIImage(named: "Twitter")
        }
    }

    @objc func shareGIF() {
        switch social {
        case .IMessage:
            NSLog("Share to IMessage")
        case .Messenger:
            NSLog("Share to Messenger")
        case .Snapchat:
            NSLog("Share to Snapchat")
        case .WhatsApp:
            NSLog("Share to WhatsApp")
        case .Instagram:
            NSLog("Share to Instagram")
        case .Facebook:
            NSLog("Share to Facebook")
        case .Twitter:
            NSLog("Share to Twitter")
        case .none:
            NSLog("Unknown Error")
        }
    }
}
