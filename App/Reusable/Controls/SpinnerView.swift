//
//  SpinnerView.swift
//  VFPoC
//
//  Created by Sergey Gorin on 13/03/2019.
//  Copyright © 2019 Sergey Gorin. All rights reserved.
//

import UIKit

class SpinnerView: UIActivityIndicatorView {
    
    static let id = NSUUID().uuidString + ".spinnerViewKey"
    
    typealias Configurator = (_ indicatorView: SpinnerView, _ parent: UIView) -> ()
    
    convenience init(withId id: String = SpinnerView.id,
                     in view: UIView,
                     applying configurator: Configurator = { sp, _ in sp.xt.attachEdges() }) {
        self.init()
        clipsToBounds = true
        accessibilityIdentifier = id
        view.addSubview(self)
        
        configurator(self, view)
    }
    
    override func startAnimating() {
        start()
    }
    
    func start() {
        if !isAnimating {
            super.startAnimating()
        }
    }
    
    func stop(andRemove: Bool = true) {
        stopAnimating()
        if andRemove {
            removeFromSuperview()
        }
    }
}

extension UIView {
    
    var spinner: SpinnerView {
        return (xt.getSubview(withId: SpinnerView.id) as? SpinnerView) ?? SpinnerView(in: self).with {
            $0.backgroundColor = .tbxVeryLightPink
        }
    }
}
