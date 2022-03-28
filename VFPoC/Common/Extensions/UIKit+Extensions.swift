//
//  UIKit+Extensions.swift
//  VFPoC
//
//  Created by Sergey Gorin on 04/02/2019.
//  Copyright © 2019 Sergey Gorin. All rights reserved.
//

import UIKit

extension UIColor {
    
    static var random: UIColor {
        return UIColor(
            red: .random(in: 0 ... 1),
            green: .random(in: 0 ... 1),
            blue: .random(in: 0 ... 1),
            alpha: 1
        )
    }
}

extension UIScrollView {
    
    public func translation(in view: UIView? = nil) -> CGPoint {
        return panGestureRecognizer.translation(in: view ?? self)
    }
    
    public func velocity(in view: UIView? = nil) -> CGPoint {
        return panGestureRecognizer.velocity(in: view ?? self)
    }
}

extension UICollectionViewCell {
    
    static var unexpected: UICollectionViewCell {
        return UICollectionViewCell().with { _ in
            assert(false, "Unexpected cell type")
        }
    }
}

extension UIView: UIKitMetricsProvider {}

extension UIViewController: UIKitMetricsProvider {}

extension UIViewController {
    
    func setNavigationBarHidden(_ hidden: Bool, withDuration duration: TimeInterval = 0.3) {
        UIView.animate(withDuration: duration) {
            self.navigationController?.setNavigationBarHidden(hidden, animated: false)
        }
    }
    
    var isTabBarHidden: Bool {
        guard let tabBar = tabBarController?.tabBar else { return false }
        return tabBar.frame.origin.y > view.frame.maxY
    }
    
    func setTabBarHidden(_ isHidden: Bool, withDuration duration: TimeInterval = 0.25) {
        guard let tabBar = tabBarController?.tabBar, isTabBarHidden != isHidden else { return }
    
        UIView.animate(withDuration: duration) {
//            tabBar.frame = frame.offsetBy(dx: 0,
//                                          dy: isHidden ? frame.height : -frame.height)
            tabBar.transform = isHidden
                ? CGAffineTransform(translationX: 0, y: tabBar.frame.height + 1)
                :.identity
        }
    }
}
