//
//  GIFCell.swift
//  giphyAppTestTask
//
//  Created by Stefan Boblic on 21.04.2023.
//

import UIKit
import SnapKit
import Kingfisher

class GIFCell: UICollectionViewCell, ReusableView {

    private let GIFImage = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        self.layer.cornerRadius = 4
        self.backgroundColor = .randomColor
        self.layer.masksToBounds = true

        switchLoading(start: true)

        addSubview(GIFImage)
    }

    private func setupConstraints() {
        GIFImage.snp.makeConstraints { make in
            make.top.bottom.left.right.equalTo(0)
        }
    }

    public func setImage(imageUrl: String?) {
        if let imageUrl = imageUrl, let url = URL(string: imageUrl) {
            self.GIFImage.kf.setImage(
                with: url,
                placeholder: nil,
                options: [
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(0.2)),
                    .cacheOriginalImage
                ],
                completionHandler: { _ in
                    self.switchLoading(start: false)
                }
            )
        } else {
            self.GIFImage.image = UIImage(named: "unknown")
        }
    }

    override func prepareForReuse() {
        self.GIFImage.kf.cancelDownloadTask()

        self.GIFImage.image = nil
        self.switchLoading(start: true)
    }

    private func switchLoading(start: Bool) {
        if start {
            self.startShimmeringAnimation()
        } else {
            self.stopShimmeringAnimation()
        }
    }
}
