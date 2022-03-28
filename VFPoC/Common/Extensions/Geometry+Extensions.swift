//
//  Geometry+Extensions.swift
//  VFPoC
//
//  Created by Sergey Gorin on 04/02/2019.
//  Copyright © 2019 Sergey Gorin. All rights reserved.
//

import CoreGraphics
import UIKit.UIGeometry

extension CGFloat {
    
    var half: CGFloat { return self * 0.5 }
}

extension CGSize {
    
    /// Exchange width and height
    var swapped: CGSize {
        return CGSize(width: height, height: width)
    }
    
    var isLandscape: Bool {
        return width > height
    }
    
    static func + (lhs: CGSize, rhs: CGSize) -> CGSize {
        return CGSize(width: lhs.width + rhs.width,
                      height: lhs.height + rhs.height)
    }
    
    static func - (lhs: CGSize, rhs: CGSize) -> CGSize {
        return CGSize(width: lhs.width - rhs.width,
                      height: lhs.height - rhs.height)
    }
    
//    static func >= (lhs: CGSize, rhs: CGSize) -> Bool {
//        return CGSize lhs.width >= rhs.width
//    }
}

extension UIEdgeInsets {
    
    var leftRight: CGFloat {
        return left + right
    }
    
    var topBottom: CGFloat {
        return top + bottom
    }
    
    static func apply(top: CGFloat = 0.0,
                      left: CGFloat = 0.0,
                      bottom: CGFloat = 0.0,
                      right: CGFloat = 0.0) -> UIEdgeInsets {
        return UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }
}
