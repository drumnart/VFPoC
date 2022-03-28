//
//  VideoPlayerView.swift
//  VFPoC
//
//  Created by Sergey Gorin on 05/02/2019.
//  Copyright © 2019 Sergey Gorin. All rights reserved.
//

import UIKit
import AVFoundation

class VideoPlayerView: UIView {
    
    var player: AVPlayer? {
        get {
            return playerLayer?.player
        }
        set {
            setPlayer(newValue)
        }
    }
    
    var playerLayer: AVPlayerLayer? {
        return layer as? AVPlayerLayer
    }
    
    var isPaused: Bool {
        return player?.timeControlStatus == .paused
    }
    
    var isMuted: Bool {
        return player?.volume == 0.0
    }
    
    /// Whether the player is currently in loop mode or not
    private(set) var isLooping = false
    
    private lazy var onTapClosure: (() -> ()) = didTap
    private lazy var onDoubleTapClosure: (() -> ()) = didDoubleTap
    private var onVolumeDidChangeClosure: ((_ volume: Float) -> ())?
    
    lazy var playPauseButton = WidenTouchAreaButton(type: .custom).with {
        $0.isUserInteractionEnabled = false
        $0.setImage(Asset.volumeOn.image, for: .normal)
        $0.setImage(Asset.volumeOff.image, for: .selected)
    }
    
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    init(player: AVPlayer = AVPlayer(playerItem: nil)) {
        super.init(frame: .zero)
        configure(with: player)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure(with: nil)
    }
    
    deinit {
        stopLooping()
        removeObservers()
    }
}

extension VideoPlayerView {
    
    func configure(with player: AVPlayer?) {
        
        setPlayer(player)
        addDefaultGestureRecognizers()
        
        playPauseButton.xt.layout(in: self) {
            $0.attachEdges([.right, .bottom],
                           insets: .apply(bottom: 13, right: 16))
            $0.size(w: 28, h: 28)
        }
        
        #if DEBUG
        addObservers()
        #endif
    }
    
    func setPlayer(_ player: AVPlayer?, videoGravity: AVLayerVideoGravity = .resizeAspectFill) {
        playerLayer?.player = player
        playerLayer?.videoGravity = videoGravity
    }
    
    func replaceCurrentItem(with item: AVPlayerItem) {
        player?.replaceCurrentItem(with: item)
    }
}

extension VideoPlayerView {
    
    func startPlayback() {
        player?.play()
    }
    
    func pausePlayback() {
        player?.pause()
    }
    
    func onTap(_ closure: @escaping () -> ()) {
        onTapClosure = closure
    }
    
    func onDoubleTap(_ closure: @escaping () -> ()) {
        onDoubleTapClosure = closure
    }
    
    func toggleVolume() {
        player?.volume == 1.0 ? mute() : unmute()
    }
    
    func mute() {
        player?.volume = 0.0
        playPauseButton.isSelected = true
    }
    
    func unmute() {
        player?.volume = 1.0
        playPauseButton.isSelected = false
    }
    
    func onVolumeDidChange(_ closure: ((_ volume: Float) -> ())?) {
        onVolumeDidChangeClosure = closure
    }
    
    func startLooping() {
        player?.actionAtItemEnd = .none
        NotificationCenter.default.addUniqueObserver(self,
                                                     selector: #selector(playerItemDidReachEnd),
                                                     name: .AVPlayerItemDidPlayToEndTime,
                                                     object: nil)
        isLooping = true
    }
    
    func stopLooping() {
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
        isLooping = false
    }
    
    @objc private func playerItemDidReachEnd(notification: Notification) {
        (notification.object as? AVPlayerItem).let {
            $0.seek(to: .zero) { _ in }
        }
    }
}
    
extension VideoPlayerView {
    
    private func addDefaultGestureRecognizers() {
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(didTap))
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap)).with {
            $0.numberOfTapsRequired = 2
        }
        singleTap.require(toFail: doubleTap)
        addGestureRecognizer(singleTap)
        addGestureRecognizer(doubleTap)
    }
    
    @objc private func didTap() {
        toggleVolume()
        onVolumeDidChangeClosure?(player?.volume ?? 0.0)
    }
    
    @objc private func didDoubleTap() {
    }
}

extension VideoPlayerView {
    
    func addObservers() {
        player?.addObserver(self,
                            forKeyPath: #keyPath(AVPlayer.status),
                            options: [.new, .initial],
                            context: nil)
        player?.addObserver(self,
                            forKeyPath: #keyPath(AVPlayer.currentItem.status),
                            options:[.new, .initial],
                            context: nil)
        
        // Watch notifications
        let center = NotificationCenter.default
        center.addUniqueObserver(self,
                                 selector: #selector(getNewErrorLogEntry),
                                 name: .AVPlayerItemNewErrorLogEntry,
                                 object: player?.currentItem)
        center.addUniqueObserver(self,
                                 selector: #selector(failedToPlayToEndTime),
                                 name: .AVPlayerItemFailedToPlayToEndTime,
                                 object: player?.currentItem)
    }
    
    func removeObservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
    // Observe If AVPlayerItem.status Changed to Fail
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey: Any]?,
                               context: UnsafeMutableRawPointer?) {
        
        if let _ = object as? AVPlayer,
            keyPath == #keyPath(AVPlayer.currentItem.status),
            let newStatusAsNumber = change?[.newKey] as? NSNumber,
            let newStatus = AVPlayerItem.Status(rawValue: newStatusAsNumber.intValue),
            newStatus == .failed,
            let error = player?.currentItem?.error {
            print("[Error]: \(error)")
        }
    }
    
    // Getting error from Notification payload
    @objc func getNewErrorLogEntry(_ notification: Notification) {
        guard let object = notification.object,
            let playerItem = object as? AVPlayerItem else {
            return
        }
        guard let errorLog = playerItem.errorLog() else {
            return
        }
        print("[Error]: \(errorLog)")
    }
    
    @objc func failedToPlayToEndTime(_ notification: Notification) {
        if let error = notification.userInfo?[AVPlayerItemFailedToPlayToEndTimeErrorKey] as? NSError {
            print("[Error]: \(error)")
        }
    }
}
