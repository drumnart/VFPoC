//
//  UIColor+Extensions.swift
//  VFPoC
//
//  Created by Sergey Gorin on 15/02/2019.
//  Copyright © 2019 Sergey Gorin. All rights reserved.
//

import UIKit

// ToBox Color palette from Zeplin

/// MARK: - Base Colors
extension UIColor {
    
    /// Black - #000000
    @nonobjc class var tbxBlack: UIColor {
        return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    /// White - #ffffff
    @nonobjc class var tbxWhite: UIColor {
        return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    /// BlackTint - #333333
    @nonobjc class var tbxBlackTint: UIColor {
        return #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
    }
    
    /// salmonPink - #f7757f
    @nonobjc class var tbxSalmonPink: UIColor {
        return #colorLiteral(red: 0.968627451, green: 0.4588235294, blue: 0.4980392157, alpha: 1)
    }
    
    /// MainTint - #f7757f
    @nonobjc class var tbxMainTint: UIColor {
        return tbxSalmonPink
    }
    
    /// VeryLightPink - #d0d0d0
    @nonobjc class var tbxVeryLightPink: UIColor {
        return #colorLiteral(red: 0.8156862745, green: 0.8156862745, blue: 0.8156862745, alpha: 1)
    }
    
    /// LightBlueGrey - #c8c7cc
    @nonobjc class var tbxLightBlueGrey: UIColor {
        return #colorLiteral(red: 0.7843137255, green: 0.7803921569, blue: 0.8, alpha: 1)
    }
    
    /// SeparatorColor
    @nonobjc class var tbxSeparatorColor: UIColor {
        return tbxLightBlueGrey
    }
}

extension UINavigationBar {
    
    static var defaultTintColor: UIColor = .tbxBlackTint
}
