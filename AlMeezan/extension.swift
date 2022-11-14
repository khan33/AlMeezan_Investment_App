//
//  extension.swift
//  AlMeezan
//
//  Created by Atta khan on 28/08/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    static let purple = UIColor().hexStringToUIColor(hex: "#8A269B")
    static let newGray = UIColor().hexStringToUIColor(hex: "#F2F4F8")
    static let gray2 = UIColor().hexStringToUIColor(hex: "#F4F5F8")
    static let btnGray = UIColor().hexStringToUIColor(hex: "#B9BBC6")
    static let customGray = UIColor().hexStringToUIColor(hex: "#F8F8F8")
    static let lightPurple = UIColor().hexStringToUIColor(hex: "#FBE8FF")
    static let offwhite = UIColor().hexStringToUIColor(hex: "#FFFFFFB3")
    static let darkGreen = UIColor().hexStringToUIColor(hex: "#008641")
    static let subHeadingColor = UIColor().hexStringToUIColor(hex: "#5B5F78")
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}
