//
//  InterestsCollectionViewCell.swift
//  VFPoC
//
//  Created by Sergey Gorin on 12/03/2019.
//  Copyright © 2019 Sergey Gorin. All rights reserved.
//

import UIKit

struct InterestsParams {
    var imageURLString: String = ""
    var title: String = ""
}

class InterestsCollectionViewCell: UICollectionViewCell {
    
    private var params = InterestsParams() {
        didSet {
            applyParams()
        }
    }
    
    lazy var imageView = UIImageView().with {
        $0.backgroundColor = .tbxWhite
    }
    
    lazy var foggingView = UIView().with {
        $0.backgroundColor = UIColor.tbxBlackTint.withAlphaComponent(0.5)
    }
    
    lazy var titleLbl = UILabel().with {
        $0.textColor = .tbxWhite
        $0.font = .semibold(ofSize: 15)
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    lazy var selectionImgView = UIImageView().with {
        $0.isHidden = true
        $0.image = Asset.picked.image
    }
    
    override var isSelected: Bool {
        didSet {
            selectionImgView.isHidden = !isSelected
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.cancelDownloading()
        imageView.image = nil
        titleLbl.text = ""
    }
    
    func configure() {
        
        if #available(iOS 11.0, *) {
            insetsLayoutMarginsFromSafeArea = false
        }
        
        imageView.xt.layout(in: contentView) {
            $0.attachEdges(to: $1, insets: .apply(bottom: 4, right: 4))
        }
        foggingView.xt.layout(in: contentView) {
            $0.attachEdges(to: imageView)
        }
        titleLbl.xt.layout(in: contentView) {
            $0.bottom(-4, to: imageView.xt.bottom)
            $0.attachEdges([.left, .right])
        }
        selectionImgView.xt.layout(in: self) {
            $0.size(w: 24, h: 24)
            $0.bottom(to: $1.xt.bottom)
            $0.trailing(to: $1.xt.trailing)
        }
        
        imageView.xt.round(cornerRadius: 4.0)
        foggingView.xt.round(cornerRadius: 4.0)
        xt.rasterize()
    }
}

extension InterestsCollectionViewCell {
    
    func inject(_ params: InterestsParams) {
        self.params = params
    }
    
    private func applyParams() {
        imageView.loadImage(withURLString: params.imageURLString) {
            if case .success = $0 {
                $1?.backgroundColor = .tbxWhite
            }
        }
        titleLbl.text = params.title
    }
}
