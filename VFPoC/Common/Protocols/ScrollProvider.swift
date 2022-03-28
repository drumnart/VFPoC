//
//  ScrollProvider.swift
//  VFPoC
//
//  Created by Sergey Gorin on 25/02/2019.
//  Copyright © 2019 Sergey Gorin. All rights reserved.
//

import UIKit

enum ScrollAction {
    case didScroll
    case willBeginDragging
    case willEndDragging(velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
    case didEndDragging(willDecelerate: Bool)
    case willBeginDecelerating
    case didEndDecelerating
    case didEndScrollingAnimation
}

typealias ScrollCallback = (_ action: ScrollAction, _ scrollView: UIScrollView) -> ()

protocol ScrollProvider: class {
    var scrollCallback: ScrollCallback { get set }
    var scrollRatio: CGPoint { get }
    var supposedPage: Int { get }
}

extension ScrollProvider {
    
    var scrollRatio: CGPoint { return .zero }
    
    var supposedPage: Int { return -1 }
    
    @discardableResult func onScrollAction(_ callback: @escaping ScrollCallback) -> Self {
        self.scrollCallback = callback
        return self
    }
}
