//
//  File.swift
//  tictacto
//
//  Created by Brad Phillips on 10/12/18.
//  Copyright © 2018 megaBreezy. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    /**
     * This extension allows us to create an instance of UIColor
     * converted from a hex color, like so:
     *   UIColor(hexFromString: "#ffffff") //would give us white
     */
    convenience init(hexFromString:String, alpha:CGFloat = 1.0) {
        var colorString : String = hexFromString.trimmingCharacters(
            in: .whitespacesAndNewlines).uppercased()
        var rgbValue : UInt32 = 10066329 //default to #999999, worst-case
        
        if (colorString.hasPrefix("#")) {
            colorString.remove(at: colorString.startIndex)
        }
        
        if (colorString.count == 6) {
            Scanner(string: colorString).scanHexInt32(&rgbValue)
        }
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255,
                  alpha: alpha)
    }
}
