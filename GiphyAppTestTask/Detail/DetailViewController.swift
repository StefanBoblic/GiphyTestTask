//
//  DetailViewController.swift
//  GiphyAppTestTask
//
//  Created by Stefan Boblic on 21.04.2023.
//

import UIKit
import SnapKit
import Kingfisher

class DetailViewController: UIViewController {

    let closeButton = UIButton()
    let shareButton = UIButton()

    let previewImage = UIImageView()

    let shareButtonsStack = UIStackView()
    let mainButtonsStack = UIStackView()

    var previewIsLoaded: Bool = false
    var currentGIFLink: String! = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        if !previewIsLoaded {
            switchLoading(start: true)
        }
    }

    public func setGIF(imageUrl: String?) {
        currentGIFLink = imageUrl

        if let imageUrl = imageUrl, let url = URL(string: imageUrl) {
            self.previewImage.kf.setImage(
                with: url,
                placeholder: nil,
                options: [
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(0.2)),
                    .cacheOriginalImage
                ],
                completionHandler: { _ in
                    self.switchLoading(start: false)
                    self.previewIsLoaded = true
                }
            )
        } else {
            self.previewImage.image = UIImage(named: "unknown")
        }
    }

    private func setupLayout() {
        setupUI()
        setupConstraints()
    }

    private func setupUI() {

        self.view.backgroundColor = UIColor(named: "backgroundColor")

        // configure preview image
        previewImage.layer.cornerRadius = 4
        previewImage.backgroundColor = .randomColor
        previewImage.contentMode = .scaleAspectFill
        previewImage.layer.masksToBounds = true

        self.view.addSubview(previewImage)

        // configure navigation buttons
        var closeButtonConfig = UIButton.Configuration.borderless()
        closeButtonConfig.image = UIImage(systemName: "xmark")
        closeButtonConfig.baseForegroundColor = .white
        closeButtonConfig.buttonSize = .medium
        closeButtonConfig.contentInsets = .init(top: 20, leading: 20, bottom: 20, trailing: 20)
        closeButton.configuration = closeButtonConfig
        closeButton.addTarget(self, action: #selector(quitDetail), for: .touchUpInside)

        var shareButtonConfig = UIButton.Configuration.borderless()
        shareButtonConfig.image = UIImage(systemName: "square.and.arrow.up")
        shareButtonConfig.baseForegroundColor = .white
        shareButtonConfig.buttonSize = .medium
        shareButtonConfig.contentInsets = .init(top: 20, leading: 20, bottom: 20, trailing: 20)
        shareButton.configuration = shareButtonConfig

        self.view.addSubview(closeButton)
        self.view.addSubview(shareButton)

        // configure share buttons stack
        let socials: [Social] = [.IMessage, .Messenger, .Snapchat, .WhatsApp, .Instagram, .Facebook, .Twitter]
        for social in socials {
            let socialButton = SocialImageButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
            socialButton.setupSocialButton(for: social)
            shareButtonsStack.addArrangedSubview(socialButton)
        }

        shareButtonsStack.axis = .horizontal
        shareButtonsStack.alignment = .center
        shareButtonsStack.distribution = .fillEqually
        shareButtonsStack.spacing = 8

        self.view.addSubview(shareButtonsStack)

        // configure three buttons
        var mainButtonConfiguration = UIButton.Configuration.borderless()
        mainButtonConfiguration.baseForegroundColor = .white
        mainButtonConfiguration.buttonSize = .large
        mainButtonConfiguration.contentInsets = .init(top: 20, leading: 80, bottom: 20, trailing: 80)

        let copyLinkButton = UIButton(configuration: mainButtonConfiguration)
        copyLinkButton.setTitle("Copy GIF Link", for: .normal)
        copyLinkButton.backgroundColor = UIColor(named: "MainButtonColor")
        copyLinkButton.addTarget(self, action: #selector(copyLink), for: .touchUpInside)

        let copyGIFButton = UIButton(configuration: mainButtonConfiguration)
        copyGIFButton.setTitle("Copy GIF", for: .normal)
        copyGIFButton.backgroundColor = .white.withAlphaComponent(0.2)
        copyLinkButton.addTarget(self, action: #selector(copyGIF), for: .touchUpInside)

        let cancelButton = UIButton(configuration: mainButtonConfiguration)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.backgroundColor = .clear
        cancelButton.addTarget(self, action: #selector(quitDetail), for: .touchUpInside)

        mainButtonsStack.addArrangedSubview(copyLinkButton)
        mainButtonsStack.addArrangedSubview(copyGIFButton)
        mainButtonsStack.addArrangedSubview(cancelButton)

        mainButtonsStack.axis = .vertical
        mainButtonsStack.distribution = .fillEqually
        mainButtonsStack.spacing = 8

        self.view.addSubview(mainButtonsStack)
    }

    private func setupConstraints() {
        closeButton.snp.makeConstraints { make in
            make.left.top.equalTo(self.view.safeAreaLayoutGuide).offset(20)
        }

        shareButton.snp.makeConstraints { make in
            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(-10)
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(10)
        }

        previewImage.snp.makeConstraints { make in
            make.height.width.equalTo(self.view.frame.width - 40)
            make.centerX.equalTo(self.view)
            make.top.equalTo(120)
        }

        shareButtonsStack.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.top.equalTo(previewImage.snp.bottom).offset(80)
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }

        mainButtonsStack.snp.makeConstraints { make in
            make.width.equalTo(self.view.frame.width - 40)
            make.height.equalTo(148)
            make.top.equalTo(shareButtonsStack.snp.bottom).offset(8)
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }
    }

    @objc func copyGIF() {
        UIPasteboard.general.image = previewImage.image
    }

    @objc func copyLink() {
        UIPasteboard.general.string = currentGIFLink
    }

    @objc func quitDetail() {
        self.dismiss(animated: true)
    }

    private func switchLoading(start: Bool) {
        if start {
            previewImage.startShimmeringAnimation()
        } else {
            previewImage.stopShimmeringAnimation()
        }
    }
}
