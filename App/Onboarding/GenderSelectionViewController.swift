//
//  GenderSelectionViewController.swift
//  VFPoC
//
//  Created by Sergey Gorin on 25/02/2019.
//  Copyright © 2019 Sergey Gorin. All rights reserved.
//

import UIKit

extension GenderSelectionViewController {
    
    func inject(_ state: OnboardingState?) {
        self.state = state
    }
}

class GenderSelectionViewController: UIViewController {
    
    var genderSelection: ((Gender) -> Void)?
    
    var selected: Gender = .unknown {
        didSet {
            guard selected != oldValue else { return }
            genderSelection?(selected)
            updateSelection()
        }
    }
    
    private weak var state: OnboardingState? {
        didSet {
            selected = state?.gender ?? .unknown
            updateSelection()
        }
    }
    
    lazy var titleLbl = UILabel().with {
        $0.numberOfLines = 1
        $0.textColor = .tbxBlackTint
        $0.textAlignment = .center
        $0.font = .light(ofSize: 17)
        $0.text = L10n.Onboarding.Gender.text1
    }
    
    lazy var separator = LineView(lineColor: .tbxMainTint)
    
    lazy var descriptionLbl = UILabel().with {
        $0.numberOfLines = 0
        $0.textColor = .tbxBlackTint
        $0.textAlignment = .center
        $0.font = .light(ofSize: 14)
        $0.text = L10n.Onboarding.Gender.text2
    }
    
    lazy var femaleBtn = UIButton(type: .custom).with {
        $0.setImage(Asset.femaleIcon.image, for: [])
        $0.setImage(Asset.femaleIconSelected.image, for: .highlighted)
        $0.setImage(Asset.femaleIconSelected.image, for: .selected)
        $0.setBackgroundImage(.fromColor(.tbxWhite), for: [])
        $0.setBackgroundImage(.fromColor(.tbxMainTint), for: .highlighted)
        $0.setBackgroundImage(.fromColor(.tbxMainTint), for: .selected)
        $0.xt.round(
            borderWidth: 2.0,
            borderColor: .tbxMainTint,
            cornerRadius: 60
        )
        $0.onAction { [unowned self] _ in
            self.selected = .female
        }
    }
    
    lazy var femaleSelectedImgView = UIImageView().with {
        $0.isHidden = true
        $0.image = Asset.picked.image
    }
    
    lazy var femaleLbl = UILabel().with {
        $0.numberOfLines = 1
        $0.textColor = .tbxMainTint
        $0.textAlignment = .center
        $0.font = .regular(ofSize: 15)
        $0.text = L10n.Gender.female
    }
    
    lazy var maleBtn = UIButton(type: .custom).with {
        $0.setImage(Asset.maleIcon.image, for: [])
        $0.setImage(Asset.maleIconSelected.image, for: .highlighted)
        $0.setImage(Asset.maleIconSelected.image, for: .selected)
        $0.setBackgroundImage(.fromColor(.tbxWhite), for: [])
        $0.setBackgroundImage(.fromColor(.tbxMainTint), for: .highlighted)
        $0.setBackgroundImage(.fromColor(.tbxMainTint), for: .selected)
        $0.xt.round(
            borderWidth: 2.0,
            borderColor: .tbxMainTint,
            cornerRadius: 60
        )
        $0.onAction { [unowned self] _ in
            self.selected = .male
        }
    }
    
    lazy var maleSelectedImgView = UIImageView().with {
        $0.isHidden = true
        $0.image = Asset.picked.image
    }
    
    lazy var maleLbl = UILabel().with {
        $0.numberOfLines = 1
        $0.textColor = .tbxMainTint
        $0.textAlignment = .center
        $0.font = .regular(ofSize: 15)
        $0.text = L10n.Gender.male
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

extension GenderSelectionViewController {
    func configure() {
        view.backgroundColor = .tbxWhite
        
        titleLbl.xt.layout(in: view) {
            $0.top(56, to: view.topAnchor)
            $0.centerX(equalTo: view)
            $0.height(20)
        }
        
        separator.xt.layout(in: view) {
            $0.top(20, to: titleLbl.bottomAnchor)
            $0.centerX(equalTo: view)
            $0.size(w: 56, h: 2)
        }
        
        descriptionLbl.xt.layout(in: view) {
            $0.top(20, to: separator.bottomAnchor)
            $0.centerX(equalTo: view)
            $0.size(w: 280, h: 36)
        }
        
        femaleBtn.xt.layout(in: view) {
            $0.top(44, to: descriptionLbl.bottomAnchor)
            $0.leading(to: descriptionLbl.leadingAnchor)
            $0.size(w: 120, h: 120)
        }
        
        femaleSelectedImgView.xt.layout(in: view) {
            $0.size(w: 24, h: 24)
            $0.bottom(to: femaleBtn.bottomAnchor)
            $0.trailing(-12, to: femaleBtn.trailingAnchor)
        }
        
        femaleLbl.xt.layout(in: view) {
            $0.top(10, to: femaleBtn.bottomAnchor)
            $0.centerX(equalTo: femaleBtn)
            $0.height(20)
        }
        
        maleBtn.xt.layout(in: view) {
            $0.top(44, to: descriptionLbl.bottomAnchor)
            $0.trailing(to: descriptionLbl.trailingAnchor)
            $0.size(w: 120, h: 120)
        }
        
        maleSelectedImgView.xt.layout(in: view) {
            $0.size(w: 24, h: 24)
            $0.bottom(to: maleBtn.bottomAnchor)
            $0.trailing(-12, to: maleBtn.trailingAnchor)
        }
        
        maleLbl.xt.layout(in: view) {
            $0.top(10, to: maleBtn.bottomAnchor)
            $0.centerX(equalTo: maleBtn)
            $0.height(20)
        }
    }
    
    func onGenderChanged(_ closure: ((Gender) -> Void)?) {
        genderSelection = closure
    }
    
    private func updateSelection() {
        femaleBtn.isSelected = selected == .female
        maleBtn.isSelected = selected == .male
        femaleSelectedImgView.isHidden = selected != .female
        maleSelectedImgView.isHidden = selected != .male
    }
}
