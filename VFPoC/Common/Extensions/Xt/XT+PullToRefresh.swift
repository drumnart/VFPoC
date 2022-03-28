//
//  Xt+PullToRefresh.swift
//  VFPoC
//
//  Created by Sergey Gorin on 19/03/2019.
//  Copyright © 2019 Sergey Gorin. All rights reserved.
//

import UIKit.UIScrollView

// MARK: - `UIScrollView` + PullToRefresh
extension Xt where Base: UIScrollView {
    
    /// Another name for `refreshControl`
    public var refreshView: UIRefreshControl? {
        return _refreshControl
    }
    
    /// Refresh Status
    public var isRefreshing: Bool {
        return _refreshControl?.isRefreshing ?? false
    }
    
    /// Can be used to add and cofigure custom refreshControl if needed.
    @discardableResult
    public func setupRefreshControl(_ closure: () -> UIRefreshControl) -> Self {
        let refreshControl = closure()
        refreshControl.addTarget(self, action: #selector(base.pullToRefresh(_:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            base.refreshControl = refreshControl
        } else {
            base.addSubview(refreshControl)
        }
        return self
    }
    
    /// Used to add and cofigure refreshControl (just another way using @autoclosure).
    @discardableResult
    public func addRefreshControl(_ closure: @autoclosure () -> UIRefreshControl) -> Self {
        return setupRefreshControl(closure)
    }
    
    /// Used for handling PullToRefresh action. Creates instance of UIRefreshControl if it doesn't already exist.
    @discardableResult
    public func onPullToRefresh(_ closure: @escaping UIScrollView.PullToRefreshCallback) -> Self {
        if _refreshControl == nil { addRefreshControl(UIRefreshControl()) }
        base.pullToRefreshCallback = closure
        return self
    }
    
    /// Starts animating `refreshControl`
    public func beginRefreshing() {
        _refreshControl?.beginRefreshing()
    }
    
    /// Stops animating `refreshControl`
    public func endRefreshing() {
        _refreshControl?.endRefreshing()
    }
    
    private var _refreshControl: UIRefreshControl? {
        if #available(iOS 10.0, *) {
            return base.refreshControl
        } else {
            return base.subviews.filter { $0 is UIRefreshControl }.first as? UIRefreshControl
        }
    }
}

extension UIScrollView {
    
    public typealias PullToRefreshCallback = (_ sender: UIRefreshControl) -> ()
    
    @objc fileprivate func pullToRefresh(_ sender: UIRefreshControl) {
        pullToRefreshCallback?(sender)
    }
    
    private struct Keys {
        fileprivate static let pullToRefresh = AssociatedKey("pullToRefreshKey_" + UUID().uuidString)
    }
    
    fileprivate var pullToRefreshCallback: PullToRefreshCallback? {
        get { return getAssociatedObject(forKey: Keys.pullToRefresh) }
        set { setAssociatedObject(newValue, forKey: Keys.pullToRefresh) }
    }
}
