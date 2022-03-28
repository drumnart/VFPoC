//
//  UIImage+Extensions.swift
//  VFPoC
//
//  Created by Sergey Gorin on 15/02/2019.
//  Copyright © 2019 Sergey Gorin. All rights reserved.
//

import UIKit

extension UIImage {
    
    class func fromColor(_ color: UIColor, opaque: Bool = false,
                         size: CGSize = CGSize(width: 1.0, height: 1.0)) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, opaque, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
