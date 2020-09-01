//
//  UIColor+hex.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 01.09.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import UIKit

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            let hasAlpha = hexColor.count == 8
            let validHexColor = hexColor.count == 8 || hexColor.count == 6
            if validHexColor {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    if hasAlpha {
                        self.init(red: r, green: g, blue: b, alpha: a)
                    } else {
                        self.init(red: g, green: b, blue: a, alpha: 1.0)
                    }

                    return
                }
            }
        }

        return nil
    }
}
