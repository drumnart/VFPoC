//
//  VideoFeedCollectionViewCell.swift
//  VFPoC
//
//  Created by Sergey Gorin on 05/02/2019.
//  Copyright © 2019 Sergey Gorin. All rights reserved.
//

import UIKit
import AVFoundation.AVPlayerItem

class VideoFeedCollectionViewCell: UICollectionViewCell {
    
    struct Settings {
        var avatarSize = CGSize(width: 36, height: 36)
    }
    
    var settings = Settings()
    
    struct Params {
        var price: String
        var originalPrice: String
    }
    
    var videoPath: String? {
        didSet {
            URL(string: videoPath ?? "").let {
                videoPlayerView.replaceCurrentItem(with: AVPlayerItem(url: $0))
                
                observer = videoPlayerView.player?.currentItem?.observe(\.status, options: .new) { [unowned self] (item, change) in
                    if item.status == .readyToPlay {
                        UIView.animate(withDuration: 0.2) {
                            self.videoPlayerView.alpha = 1.0
                        }
                        self.startPlayback()
                    }
                }
            }
        }
    }
    
    var imagePaths: [String] = [] {
        didSet {
            if let firstPath = imagePaths.first {
                previewImageView.loadImage(withURLString: firstPath) {
                    if case .success = $0 {
                        $1?.backgroundColor = .tbxWhite
                    }
                }
            }
        }
    }
    
    var shopTitle: String = "" {
        didSet {
            shopTitleLabel.text = shopTitle
        }
    }
    
    var shopAvatarPath: String = "" {
        didSet {
            shopAvatar.loadImage(withURLString: shopAvatarPath) {
                if case .success = $0 {
                    $1?.backgroundColor = .tbxWhite
                }
            }
        }
    }
    
    var title: String = "" {
        didSet {
            titleLbl.text = title
        }
    }
    
    var price: String = "" {
        didSet {
            priceLabel.text = price
        }
    }
    
    var originalPrice: String = "" {
        didSet {
            if originalPrice.isBlank {
                originalPriceLabel.isHidden = true
            } else {
                originalPriceLabel.isHidden = false
            }
            
            let originalPriceAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.tbxVeryLightPink,
                .font: UIFont.regular(ofSize: 15),
                .strikethroughStyle: NSUnderlineStyle.single.rawValue
            ]
            originalPriceLabel.attributedText = NSAttributedString(
                string: originalPrice,
                attributes: originalPriceAttributes
            )
        }
    }
    
    var isLiked: Bool = false {
        didSet {
            likeBtn.isSelected = isLiked
        }
    }
    
    var likesCount: String = "" {
        didSet {
            likesCountLbl.text = likesCount
        }
    }
    
    var isMuted: Bool {
        get {
            return videoPlayerView.isMuted
        }
        set {
            newValue ? mute() : unmute()
        }
    }
    
    lazy var videoPlayerView = VideoPlayerView().with {
        $0.backgroundColor = .clear
        $0.alpha = 0.0
        $0.startLooping()
        $0.mute()
    }
    
    lazy var previewImageView = UIImageView().with {
        $0.backgroundColor = .tbxLightBlueGrey
    }
    
    lazy var shopAvatar = UIImageView().with {
        $0.backgroundColor = .lightGray
        $0.layer.cornerRadius = settings.avatarSize.height.half
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
    }
    
    lazy var shopTitleLabel = UILabel().with {
        $0.textColor = .tbxBlack
        $0.font = .regular(ofSize: 15)
    }
    
    lazy var priceLabel = UILabel().with {
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.5
        $0.numberOfLines = 1
        $0.textColor = .tbxBlack
        $0.textAlignment = .left
        $0.font = .regular(ofSize: 19)
    }
    
    lazy var originalPriceLabel = UILabel().with {
        $0.isHidden = true
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.5
        $0.numberOfLines = 1
        $0.textColor = .tbxVeryLightPink
        $0.textAlignment = .left
        $0.font = .regular(ofSize: 15)
    }
    
    lazy var detailsBtn = UIButton(type: .custom).with {
        $0.backgroundColor = .tbxMainTint
        $0.titleLabel?.textColor = .tbxWhite
        $0.clipsToBounds = true
        $0.titleLabel?.font = .systemFont(ofSize: 14)
        $0.setTitle(L10n.Feed.shopNow, for: [])
        $0.xt.round(cornerRadius: 4.0)
    }
    
    lazy var separator = LineView(lineColor: .tbxLightBlueGrey)
    
    lazy var likeBtn = UIButton(type: .custom).with {
        $0.setImage(Asset.like.image, for: .normal)
        $0.setImage(Asset.likeSelected.image, for: .highlighted)
        $0.setImage(Asset.likeSelected.image, for: .selected)
    }
    
    lazy var bubbleBtn = UIButton(type: .custom).with {
        $0.setImage(Asset.bubble.image, for: [])
    }
    
    lazy var shareBtn = UIButton(type: .custom).with {
        $0.setImage(Asset.share.image, for: [])
    }
    
    lazy var likesCountLbl = UILabel().with {
        $0.numberOfLines = 1
        $0.textColor = .tbxBlack
        $0.textAlignment = .left
        $0.font = .systemFont(ofSize: 15, weight: .medium)
    }
    
    lazy var titleLbl = UILabel().with {
        $0.numberOfLines = 2
        $0.textColor = .tbxBlackTint
        $0.textAlignment = .left
        $0.font = .systemFont(ofSize: 15)
    }
    
    private var observer: NSKeyValueObservation?
    
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
        observer?.invalidate()
        previewImageView.cancelDownloading()
        previewImageView.image = nil
        shopAvatar.cancelDownloading()
        shopAvatar.image = nil
        videoPlayerView.alpha = 0.0
        isMuted = true
        priceLabel.text = ""
        originalPriceLabel.text = ""
    }
    
    func configure() {
        
        if #available(iOS 11.0, *) {
            insetsLayoutMarginsFromSafeArea = false
        }
        
        backgroundColor = .tbxWhite
        
        shopAvatar.xt.layout(in: contentView) {
            $0.attachEdges([.top, .left],
                           insets: .apply(top: 8, left: 16))
            $0.size(settings.avatarSize)
        }
        
        shopTitleLabel.xt.layout(in: contentView) {
            $0.centerY(equalTo: shopAvatar)
            $0.leading(12, to: shopAvatar.trailingAnchor)
            $0.trailing(-16, to: contentView.trailingAnchor)
            $0.height(equalTo: shopAvatar)
        }
        
        previewImageView.xt.layout(in: contentView) {
            $0.attachEdges([.left, .right])
            $0.top(8, to: shopAvatar.bottomAnchor)
            $0.height(frame.width * 0.75)
        }
        
        videoPlayerView.xt.layout(in: contentView) {
            $0.attachEdges([.left, .right])
            $0.top(8, to: shopAvatar.bottomAnchor)
            $0.height(frame.width * 0.75)
        }
        
        priceLabel.xt.layout(in: contentView) {
            $0.attachEdges([.left], insets: .apply(left: 16))
            $0.height(23)
            $0.top(13, to: videoPlayerView.bottomAnchor)
        }
        
        originalPriceLabel.xt.layout(in: contentView) {
            $0.leading(7, to: priceLabel.xt.trailing)
            $0.height(18)
            $0.bottom(-1, to: priceLabel.xt.bottom)
        }
        
        detailsBtn.xt.layout(in: contentView) {
            $0.top(6, to: videoPlayerView.bottomAnchor)
            $0.trailing(-16, to: contentView.trailingAnchor)
            $0.size(w: 104, h: 36)
            $0.rasterize()
        }
        
        separator.xt.layout(in: contentView) {
            $0.top(6, to: detailsBtn.bottomAnchor)
            $0.attachEdges([.left, .right],
                           insets: .apply(left: 8, right: 8))
            $0.height(0.5)
        }
        
        likeBtn.xt.layout(in: contentView) {
            $0.top(8, to: separator.bottomAnchor)
            $0.leading(16, to: contentView.leadingAnchor)
            $0.size(w: 24, h: 24)
        }
        
        bubbleBtn.xt.layout(in: contentView) {
            $0.top(8, to: separator.bottomAnchor)
            $0.leading(12, to: likeBtn.trailingAnchor)
            $0.size(w: 24, h: 24)
        }
        
        shareBtn.xt.layout(in: contentView) {
            $0.top(8, to: separator.bottomAnchor)
            $0.leading(12, to: bubbleBtn.trailingAnchor)
            $0.size(w: 24, h: 24)
        }
        
        likesCountLbl.xt.layout(in: contentView) {
            $0.top(9, to: likeBtn.bottomAnchor)
            $0.leading(16, to: contentView.leadingAnchor)
            $0.height(19)
        }
        
        titleLbl.xt.layout(in: contentView) {
            $0.top(6, to: likesCountLbl.bottomAnchor)
            $0.leading(16, to: contentView.leadingAnchor)
            $0.trailing(-16, to: contentView.trailingAnchor)
            $0.height(40)
        }
    }
    
    func startPlayback() {
        videoPlayerView.startPlayback()
    }
    
    func pausePlayback() {
        videoPlayerView.pausePlayback()
    }
    
    func mute() {
        videoPlayerView.mute()
    }
    
    func unmute() {
        videoPlayerView.unmute()
    }
    
    func onVolumeDidChange(_ closure: ((_ volume: Float) -> ())?) {
        videoPlayerView.onVolumeDidChange(closure)
    }
}
