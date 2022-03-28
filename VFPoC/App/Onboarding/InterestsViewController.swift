//
//  InterestsViewController.swift
//  VFPoC
//
//  Created by Sergey Gorin on 25/02/2019.
//  Copyright © 2019 Sergey Gorin. All rights reserved.
//

import UIKit

extension InterestsViewController {
    
    func inject(_ state: OnboardingState?) {
        self.state = state
    }
}

class InterestsViewController: UIViewController {
    
    struct Settings {
        var margins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    var settings = Settings()
    
    private weak var state: OnboardingState?
    
    var items: [Interest] {
        return state?.interests ?? []
    }
    
    private var selection: ((_ index: Int, _ isSelected: Bool) -> Void)?
    
    lazy var spinner = SpinnerView(in: collectionView) {
        $0.color = .tbxSalmonPink
        $0.xt.center(equalTo: $1)
    }
    
    lazy var titleLbl = UILabel().with {
        $0.numberOfLines = 2
        $0.textColor = .tbxBlackTint
        $0.textAlignment = .center
        $0.font = .light(ofSize: 17)
        $0.text = L10n.Onboarding.Preferences.text1
    }
    
    lazy var separator = LineView(lineColor: .tbxMainTint)
    
    lazy var descriptionLbl = UILabel().with {
        $0.numberOfLines = 2
        $0.textColor = .tbxBlackTint
        $0.textAlignment = .center
        $0.font = .light(ofSize: 14)
        $0.text = L10n.Onboarding.Preferences.text2
    }
    
    lazy var layout = UICollectionViewFlowLayout().with {
        $0.minimumInteritemSpacing = 4
        $0.minimumLineSpacing = 4
        $0.sectionInset = .zero
        $0.itemSize = view.xt.chunkSize(
            interItemSpacing: $0.minimumInteritemSpacing,
            margins: settings.margins,
            maxItemsPerRow: 3
        )
    }
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).with {
        $0.backgroundColor = .tbxWhite
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
        if #available(iOS 11.0, *) {
            $0.contentInsetAdjustmentBehavior = .never
        }
        $0.scrollsToTop = true
        $0.dataSource = self
        $0.delegate = self
        $0.allowsMultipleSelection = true
        $0.register(InterestsCollectionViewCell.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        state?.fetchInterests()
    }
}

extension InterestsViewController {
    
    func configure() {
        view.backgroundColor = .tbxWhite
        
        view.xt.addSubviews(titleLbl, separator, descriptionLbl, collectionView)
        
        titleLbl.xt.layout {
            $0.top(56, to: view.xt.top)
            $0.attachEdges([.left, .right], insets: .apply(left: 16, right: 16))
        }
        
        separator.xt.layout {
            $0.top(20, to: titleLbl.xt.bottom)
            $0.centerX(equalTo: view)
            $0.size(w: 56, h: 2)
        }
        
        descriptionLbl.xt.layout {
            $0.top(10, to: separator.xt.bottom)
            $0.centerX(equalTo: view)
            $0.size(w: 280, h: 36)
        }
        
        collectionView.xt.layout {
            $0.top(8, to: descriptionLbl.xt.bottom)
            $0.leading(settings.margins.left, to: $1.xt.leading)
            $0.trailing(-settings.margins.right, to: $1.xt.trailing)
            $0.bottom(to: $1.xt.bottom)
        }
    }
    
    func onInterestsSelectionDidChange(_ closure: ((_ index: Int, _ isSelected: Bool) -> Void)?) {
        selection = closure
    }
}

extension InterestsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueCell(InterestsCollectionViewCell.self, for: indexPath).with {
            let item = items[indexPath.item]
            $0.inject(InterestsParams(imageURLString: item.imagePath, title: item.name))
        }
    }
}

extension InterestsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selection?(indexPath.item, true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        selection?(indexPath.item, false)
    }
}
