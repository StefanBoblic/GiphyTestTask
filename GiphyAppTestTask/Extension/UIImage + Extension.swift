//
//  UIImage + Extension.swift
//  GiphyAppTestTask
//
//  Created by Stefan Boblic on 22.04.2023.
//

import UIKit

extension UIImage {

    static func gradientImageWithBounds(bounds: CGRect, colors: [CGColor?]) -> UIImage {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors

        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
