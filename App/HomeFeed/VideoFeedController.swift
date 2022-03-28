//
//  ViewController.swift
//  VFPoC
//
//  Created by Sergey Gorin on 04/02/2019.
//  Copyright © 2019 Sergey Gorin. All rights reserved.
//

import UIKit

protocol VideoFeedDataProviderSpec {
    var interests: [Interest] { get }
    var items: [Product] { get }
    func fetch(_ kind: VideoFeedController.Fetch)
    func onChange(_ closure: ((Change) -> ())?)
}

extension VideoFeedController: DependencyInjectable {
    
    func inject(_ dataProvider: VideoFeedDataProviderSpec?) {
        self.dataProvider = dataProvider
    }
    
    enum Fetch {
        case fresh(enforced: Bool)
        case more
    }
    
    typealias LoadingChange = (_ closure: LoadingState) -> Void
}

class VideoFeedController: UIViewController {
    
    struct Settings {
        var visibleRateForPlayback: CGFloat = 0.95
        var isSoundSwitchedOff = true
    }
    
    var settings = Settings()

    private var dataProvider: VideoFeedDataProviderSpec? {
        didSet {
            dataProvider?.onChange { [weak self] in
                switch $0 {
                case .startedLoading:
                    if self?.dataProvider?.items.count == 0 {
                        self?.view.spinner.start()
                    }
                case .finishedLoading:
                    self?.view.spinner.stop()
                    self?.updateHaaderContainer()
                    self?.feedCollectionView.xt.endRefreshing()
                    self?.feedCollectionView.reloadData()
                default: break
                }
            }
        }
    }
    
    private lazy var hidingBarDelegate = HidingBarDelegate().with {
        $0.bar = headerContainer
    }
    
    lazy var headerContainer = UIView().with {
        $0.backgroundColor = .tbxWhite
    }
    
    lazy var separator = LineView(lineColor: .tbxLightBlueGrey)
    
    lazy var headerListLayout = UICollectionViewFlowLayout().with {
        $0.scrollDirection = .horizontal
        $0.itemSize = CGSize(width: 56, height: 70)
        $0.minimumLineSpacing = 18
    }
    
    lazy var headerListCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: headerListLayout).with {
            if #available(iOS 11.0, *) {
                $0.contentInsetAdjustmentBehavior = .never
            }
            $0.backgroundColor = .tbxWhite
            $0.showsHorizontalScrollIndicator = false
            $0.showsVerticalScrollIndicator = false
            $0.backgroundColor = .white
            $0.scrollsToTop = false
            $0.contentInset = .apply(left: 16, right: 16)
            $0.dataSource = self
            $0.delegate = self
            $0.register(HomeInterestsItemCollectionViewCell.self)
    }
    
    lazy var feedLayout = UICollectionViewFlowLayout().with {
        $0.minimumInteritemSpacing = 0
        $0.minimumLineSpacing = 0
        $0.itemSize = CGSize(width: view.frame.width, height: view.frame.width * 0.75 + 223)
    }
    
    lazy var feedCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: feedLayout).with {
            if #available(iOS 11.0, *) {
                $0.contentInsetAdjustmentBehavior = .never
            }
            $0.backgroundColor = .tbxWhite
            $0.showsHorizontalScrollIndicator = false
            $0.showsVerticalScrollIndicator = false
            $0.keyboardDismissMode = .onDrag
            $0.scrollsToTop = true
            $0.contentInset = .apply(bottom: tabBarHeight)
            $0.dataSource = self
            $0.delegate = self
            $0.register(VideoFeedCollectionViewCell.self)
            $0.xt.onPullToRefresh { [dataProvider = self.dataProvider] _ in
                dataProvider?.fetch(.fresh(enforced: true))
            }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dataProvider?.fetch(.fresh(enforced: false))
    }
}

extension VideoFeedController {
    
    func configureViews() {
        view.backgroundColor = .tbxWhite
        edgesForExtendedLayout = [.bottom]
        
        view.xt.addSubviews(headerContainer, feedCollectionView)
        headerContainer.xt.addSubviews(headerListCollectionView, separator)
        
        headerContainer.xt.layout {
            $0.attachEdges([.left, .right])
        }
        
        hidingBarDelegate.topConstr = headerContainer.xt.top(to: view.xt.top)
        hidingBarDelegate.hidingHeightConstr = headerContainer.xt.height(0)
        
        separator.xt.layout {
            $0.attachEdges([.bottom, .left, .right])
            $0.height(0.5)
        }
        headerListCollectionView.xt.attachEdges()
        
        feedCollectionView.xt.layout {
            $0.top(to: headerContainer.xt.bottom)
            $0.attachEdges([.left, .bottom, .right])
        }
    }
    
    private func updateHaaderContainer() {
        hidingBarDelegate.hidingHeightConstr.constant = dataProvider?.interests.count > 0 ? 80 : 0
    }
}

extension VideoFeedController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case headerListCollectionView: return dataProvider?.interests.count ?? 0
        case feedCollectionView: return dataProvider?.items.count ?? 0
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case headerListCollectionView:
            return collectionView.dequeueCell(HomeInterestsItemCollectionViewCell.self, for: indexPath).with {
                guard let interest = dataProvider?.interests[indexPath.item] else { return }
                $0.inject((interest.imagePath, interest.name))
            }
        case feedCollectionView:
            return collectionView.dequeueCell(VideoFeedCollectionViewCell.self, for: indexPath).with {
                guard let item = dataProvider?.items[indexPath.item] else { return }
                $0.imagePaths = item.imagePaths(for: .screen_1_1)
                $0.videoPath = item.playlistPath
                $0.shopTitle = item.shop.name
                $0.shopAvatarPath = item.shopAvatarPath(for: .avatar_1_1)
                $0.title = item.title
                $0.price = item.isDiscounted ? item.formattedDiscount : item.formattedPrice
                $0.originalPrice = item.formattedPrice
                
                $0.likesCount = L10n.likes(item.likesCount)
    //            $0.isLiked = item.isLiked
                $0.onVolumeDidChange { [unowned self] volume in
                    self.settings.isSoundSwitchedOff = volume == 0.0
                }
                $0.shareBtn.onAction { [unowned self] _ in
                    self.share(for: indexPath)
                }
                $0.detailsBtn.onAction { [unowned self] _ in
                    self.navigationController?.pushViewController(ProductCardViewController(),
                                                                  animated: true)
                }
            }
        default: return .unexpected
        }
    }
}

extension VideoFeedController: UICollectionViewDelegateFlowLayout {
    
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        handlePayerPlayback(for: [cell])
//    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didEndDisplaying cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        (cell as? VideoFeedCollectionViewCell)?.videoPlayerView.pausePlayback()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        hidingBarDelegate.scrollViewDidScroll(scrollView)
        handlePayerPlayback(for: feedCollectionView.visibleCells)
        
        if scrollView === feedCollectionView {
            setTabBarHidden(scrollView.translation().y > 0,
                            withDuration: 0.3)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        hidingBarDelegate.scrollViewWillBeginDragging(scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        hidingBarDelegate.scrollViewDidEndDragging(scrollView, willDecelerate: decelerate)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        hidingBarDelegate.scrollViewDidEndDecelerating(scrollView)
    }
    
    func handlePayerPlayback(for cells: [UICollectionViewCell]) {
        for cell in cells as? [VideoFeedCollectionViewCell] ?? [] {
            let visibleHeight = cell.videoPlayerView.xt.visibleRect(in: feedCollectionView).height
            let minValidHeight = cell.videoPlayerView.frame.height * settings.visibleRateForPlayback
            if visibleHeight > minValidHeight {
                cell.startPlayback()
                cell.isMuted = settings.isSoundSwitchedOff
            } else {
                cell.pausePlayback()
                cell.isMuted = true
            }
        }
    }
}

extension VideoFeedController: Shareable {
    
    private func share(for indexPath: IndexPath) {
        guard let entity = dataProvider?.items[indexPath.item] else { return }
        
        let sharedText = entity.title + " " + entity.formattedPrice
        share(activityItems: [sharedText, entity.sharedUrl], in: self)
    }
}
