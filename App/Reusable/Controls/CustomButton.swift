//
//  CustomButton.swift
//  VFPoC
//
//  Created by Sergey Gorin on 25/02/2019.
//  Copyright © 2019 Sergey Gorin. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    
    var isShadowEnabled: Bool = false {
        didSet {
            updateShadow()
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            updateShadow()
        }
    }
    
    func setColor(_ color: UIColor, for: UIControl.State) {
        setBackgroundImage(.fromColor(.tbxMainTint), for: .normal)
        setBackgroundImage(.fromColor(.tbxVeryLightPink), for: .disabled)
    }
    
    private func updateShadow() {
        if isEnabled {
            xt.addShadow(
                opacity: 0.2,
                offset: CGSize(width: 0.0, height: 2.0),
                radius: 4.0,
                color: .tbxMainTint
            )
        } else {
            xt.hideShadow()
        }
    }
}
