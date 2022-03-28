//
//  VideoFeedDataProvider.swift
//  VFPoC
//
//  Created by Sergey Gorin on 04/02/2019.
//  Copyright © 2019 Sergey Gorin. All rights reserved.
//

import UIKit

class VideoFeedDataProvider: VideoFeedDataProviderSpec {
    
//    lazy var items: [FeedItem] = Streams.all.enumerated().map {
//        FeedItem(
//            streamUrl: $0.element,
//            sharedUrl: $0.element,
//            shopName: "Shop name",
//            title: "Unlike other sleep remedies that provide temporary solutions, Dodow’s light metronome.",
//            price: "$57.44",
//            isLiked: $0.offset % 2 == 0,
//            likesCount: "100,516 likes"
//        )
//    }
    
    private var selectedInterestIndex: Int = 0
    private var isEndOfList = false
    private(set) var isFreshLoad: Bool = false
    private var currentPage = 0
    private let lock = NSLock()
    
    var items: [Product] = []
    
    var interests: [Interest] {
        return UserDefaults.userInterests
    }
    
    var hasContent: Bool {
        return items.count > 0
    }
    
    private var change: ((Change) -> ())?
    
    func onChange(_ closure: ((Change) -> ())?) {
        change = closure
    }
    
    func fetch(_ kind: VideoFeedController.Fetch) {
        
        switch kind {
        case .fresh(let enforced):
            isFreshLoad = enforced || !hasContent
            if isFreshLoad {
                isEndOfList = false
                fetch()
            }
        case .more:
            guard hasContent else {
                return
            }
            isFreshLoad = false
            fetch(from: currentPage + 1)
        }
    }
    
    private func fetch(from page: Int = 0) {
        lock.lock(); defer { lock.unlock() }
        change?(.startedLoading)
        
        let params = HomeFeed.FilterParams(
            gender: UserDefaults.gender.rawValue,
            birthYear: UserDefaults.birthYear,
            preference: [UserDefaults.userInterests[safe: selectedInterestIndex]?.id ?? 0]
        )
        
        let pageParams = Pagination(page: page)
        
        TAPI.HomeFeed.fetch(params: .default, pageParams: pageParams) { [weak self] result in
            switch result {
            case let .success(payload):
                self?.items += payload.products
                self?.isEndOfList = !payload.pagination.hasNext
                self?.currentPage = payload.pagination.page
                self?.change?(.finishedLoading(.success(())))
            case let .failure(error):
                self?.change?(.finishedLoading(.failure(error)))
            }
        }
    }
}

//struct FeedItem {
//    let streamUrl: String
//    let sharedUrl: String
//    let shopName: String
//    let title: String
//    let price: String
//    let isLiked: Bool
//    let likesCount: String
//}

