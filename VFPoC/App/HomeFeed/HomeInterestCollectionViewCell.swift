//
//  HomeInterestCollectionViewCell.swift
//  VFPoC
//
//  Created by Sergey Gorin on 19/03/2019.
//  Copyright © 2019 Sergey Gorin. All rights reserved.
//

import UIKit

extension HomeInterestsItemCollectionViewCell {
    
    func inject(_ params: Params) {
        self.params = params
    }
}

class HomeInterestsItemCollectionViewCell: UICollectionViewCell {
    
    typealias Params = (
        imagePath: String,
        title: String
    )
    
    struct Settings {
        var imageInnerInsets = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
    }
    
    var settings = Settings()
    
    private var params: Params? {
        didSet {
            titleLbl.text = params?.title
            imageView.loadImage(withURLString: params?.imagePath ?? "") {
                if case .success = $0 {
                    $1?.backgroundColor = .tbxWhite
                }
            }
        }
    }
    
    lazy var imageViewCoat = UIView().with {
        $0.backgroundColor = .tbxWhite
        $0.xt.round(
            borderWidth: 1.5,
            cornerRadius: frame.width.half
        )
    }
    
    lazy var imageView = UIImageView().with {
        $0.backgroundColor = .tbxLightBlueGrey
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.xt.round(
            borderWidth: 0.5,
            borderColor: .tbxLightBlueGrey,
            cornerRadius: (frame.width - settings.imageInnerInsets.leftRight).half
        )
    }
    
    lazy var titleLbl = UILabel().with {
        $0.numberOfLines = 1
        $0.textColor = .tbxBlackTint
        $0.textAlignment = .center
        $0.font = .medium(ofSize: 11)
    }
    
    override var isSelected: Bool {
        didSet {
            imageViewCoat.layer.borderColor = isSelected
                ? UIColor.tbxBlackTint.cgColor
                : UIColor.clear.cgColor
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
        
        backgroundColor = .tbxWhite
        
        contentView.xt.addSubviews(imageViewCoat, titleLbl)
        imageViewCoat.addSubview(imageView)
        
        imageViewCoat.xt.layout {
            $0.attachEdges([.top, .left, .right])
            $0.height(equalTo: $0.width)
        }
        
        imageView.xt.attachEdges(insets: settings.imageInnerInsets)
        
        titleLbl.xt.layout {
            $0.top(1, to: imageViewCoat.xt.bottom)
            $0.attachEdges([.left, .bottom, .right])
        }
    }
}
