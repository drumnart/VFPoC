//
//  UIFont+Extensions.swift
//  VFPoC
//
//  Created by Sergey Gorin on 25/02/2019.
//  Copyright © 2019 Sergey Gorin. All rights reserved.
//

import UIKit

extension UIFont {
    
    static func baseFont(ofSize size: CGFloat, weight: UIFont.Weight) -> UIFont {
        return .systemFont(ofSize: size, weight: weight)
    }
    
    static func ultraLight(ofSize size: CGFloat) -> UIFont {
        return .baseFont(ofSize: size, weight: .ultraLight)
    }
    
    static func thin(ofSize size: CGFloat) -> UIFont {
        return .baseFont(ofSize: size, weight: .thin)
    }
    
    static func light(ofSize size: CGFloat) -> UIFont {
        return .baseFont(ofSize: size, weight: .light)
    }
    
    static func regular(ofSize size: CGFloat) -> UIFont {
        return .baseFont(ofSize: size, weight: .regular)
    }
    
    static func medium(ofSize size: CGFloat) -> UIFont {
        return .baseFont(ofSize: size, weight: .medium)
    }
    
    static func semibold(ofSize size: CGFloat) -> UIFont {
        return .baseFont(ofSize: size, weight: .semibold)
    }
    
    static func bold(ofSize size: CGFloat) -> UIFont {
        return .baseFont(ofSize: size, weight: .bold)
    }
    
    static func heavy(ofSize size: CGFloat) -> UIFont {
        return .baseFont(ofSize: size, weight: .heavy)
    }
}
