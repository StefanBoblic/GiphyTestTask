//
//  UIColor+Extension.swift
//  giphyAppTestTask
//
//  Created by Stefan Boblic on 21.04.2023.
//

import UIKit

extension UIColor {

    static var randomColor: UIColor {
        let colorArray: [UIColor?] = [
            UIColor(named: "Blue"),
            UIColor(named: "Green"),
            UIColor(named: "Pink")
        ]

        let randomIndex = Int.random(in: 0...2)
        return colorArray[randomIndex] ?? UIColor.clear
    }
}
