//
//  ContainerViewController.swift
//  VFPoC
//
//  Created by Sergey Gorin on 25/02/2019.
//  Copyright © 2019 Sergey Gorin. All rights reserved.
//

import UIKit

protocol ContainerChildDelegate {
    var view: UIView! { get set }
    
    func didLeaveVisibleBounds(of container: ContainerViewController)
    func didBecomeVisible(in container: ContainerViewController)
}

protocol ContainerViewControllerDataSource: class {
    func numberOfViewControllers(in container: ContainerViewController) -> Int
    func containerController(_ container: ContainerViewController, viewControllerFor index: Int) -> UIViewController
    func containerController(_ container: ContainerViewController, shouldScrollTo index: Int) -> Bool
}

extension ContainerViewControllerDataSource {
    func containerController(_ container: ContainerViewController, shouldScrollTo index: Int) -> Bool {
        return true
    }
}

class ContainerViewController: UIViewController, ScrollProvider {
    
//    weak var dataSource: ContainerViewControllerDataSource?
    
    struct Settings {
        var isInteractive: Bool = true
        var bounces: Bool = true
        var appearanceDuration: TimeInterval = 0.2
        var shouldFadePages: Bool = true
    }
    
    var settings = Settings()
    
    var scrollCallback: ScrollCallback = { _,_  in }
    
    enum Event {
        case didChangePosition(currentPage: Int)
        case didChangeChild(currentPage: Int)
    }
    
    typealias EventClosure = (_ event: Event) -> ()
    typealias ShouldScrollClosure = (_ scrollView: UIScrollView, _ page: Int) -> Bool
    
    private var eventClosure: EventClosure?
    private var shouldScrollClosure: ShouldScrollClosure?
    
    private var _viewControllers: [UIViewController] = [] {
        didSet {
            // set the active view controller if it is not in _viewControllers
            if let _ = _viewControllers.first, currentChildViewController == nil {
                currentChildIndex = 0
            }
            removeFromSuperview(viewsOf: oldValue)
            recalculateContentWidth()
            insertChildViewIfNeeded(at: 0)
        }
    }
    
    private(set) lazy var scrollView: UIScrollView = {
        let sv = UIScrollView (frame: self.view.bounds)
        sv.showsHorizontalScrollIndicator = false
        sv.showsVerticalScrollIndicator = false
        sv.isPagingEnabled = true
        sv.scrollsToTop = false
        sv.delegate = self
        sv.isScrollEnabled = true
        return sv
    }()
    
    var panGestureRecognizer: UIPanGestureRecognizer {
        return scrollView.panGestureRecognizer
    }
    
    var isScrollEnabled: Bool = true {
        didSet {
            scrollView.isScrollEnabled = isScrollEnabled && settings.isInteractive
        }
    }
    
    lazy var referenceChildSize: CGSize = { return self.view.bounds.size }()
    
    var supposedPage: Int {
        return Int(getCurrentPosition(in: scrollView))
    }
    
    private(set) var currentChildIndex: Int = -1 {
        didSet {
            guard let newValue = viewControllers[safe: currentChildIndex], currentChildIndex >= 0 else { return }
            transition(from: viewControllers[safe: oldValue], to: newValue)
        }
    }
    
    var viewControllers: [UIViewController] {
        get {
            let immutableCopy = _viewControllers
            return immutableCopy
        }
        set { _viewControllers = newValue }
    }
    
    var currentChildViewController: UIViewController? {
        return viewControllers[safe: currentChildIndex]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        
        scrollView.xt.layout {
            $0.top(to: $1.xt.top)
            $0.bottom(to: $1.xt.bottom)
            $0.leading(to: $1.xt.leading)
            $0.trailing(to: $1.xt.trailing)
        }
    }
}

// MARK: - Interface
extension ContainerViewController {
    
    /// Switch to child controller with given index
    func switchToChild(withIndex index: Int, animated: Bool = true) {
        guard isViewLoaded, index >= 0, index < _viewControllers.count else { return }
        var offset = scrollView.contentOffset
        offset.x = scrollView.frame.size.width * CGFloat(index)
        scrollView.setContentOffset(offset, animated: animated)
    }
    
    func shouldBounce(_ bounces: Bool) {
        scrollView.bounces = bounces
    }
    
    /// Bind with outer handler
    func onDidChange(_ closure: @escaping EventClosure) {
        eventClosure = closure
    }
    
    func shouldScroll(_ closure: ShouldScrollClosure?) {
        shouldScrollClosure = closure
    }
}

extension ContainerViewController {
    override var childForStatusBarStyle : UIViewController? {
        return currentChildViewController
    }
    
    private func removeFromSuperview(viewsOf viewControllers: [UIViewController]) {
        viewControllers.forEach { $0.view?.removeFromSuperview() }
        scrollView.sizeToFit()
    }
    
    private func recalculateContentWidth() {
//        let count = dataSource?.numberOfViewControllers(in: self) ?? 0
//        scrollView.contentSize.width = referenceChildSize.width * CGFloat(count)
        scrollView.contentSize.width = referenceChildSize.width * CGFloat(viewControllers.count)
    }
    
    private func insertChildViewIfNeeded(at index: Int) {
        guard let vc = viewControllers[safe: index] else { return }
        
        if let nc = (vc as? UINavigationController), let topController = nc.topViewController,
            !topController.isViewLoaded {
            insertSubview(nc.view, at: index)
        } else if vc.view.superview !== scrollView {
            insertSubview(vc.view, at: index)
        }
    }
    
    private func insertSubview(_ subview: UIView, at index: Int) {
        let xOffset = referenceChildSize.width * CGFloat(index)
        subview.frame.origin.x = xOffset
        subview.alpha = 0
        scrollView.addSubview(subview)
        
        subview.xt.layout {
            $0.top(to: view.xt.top)
            $0.bottom(to: view.xt.bottom)
            $0.leading(xOffset, to: scrollView.xt.leading)
            $0.width(referenceChildSize.width)
        }
        
        UIView.animate(withDuration: settings.appearanceDuration) {
            subview.alpha = 1.0
        }
    }
    
    private func transition(from fromVC: UIViewController?, to toVC: UIViewController) {
        fromVC?.willMove(toParent: nil)
        fromVC?.removeFromParent()
        addChild(toVC)
        toVC.didMove(toParent: self)
    }
    
    private func getCurrentPosition(in scrollView: UIScrollView) -> CGFloat {
        return scrollView.contentOffset.x / scrollView.frame.size.width
    }
    
    private func isChildVisible(_ childViewController: UIViewController) -> Bool {
        let containerFrame = CGRect(origin: scrollView.contentOffset,
                                    size: scrollView.frame.size)
        return childViewController.isViewLoaded && containerFrame.intersects(childViewController.view.frame)
    }
    
    private func fadePage(in scrollView: UIScrollView) {
        for (index, page) in _viewControllers.enumerated() {
            page.view.alpha = 1 - abs(abs(scrollView.contentOffset.x) - page.view.frame.width * CGFloat(index)) / page.view.frame.width
        }
    }
}

// MARK: - UIScrollViewDelegate
extension ContainerViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard shouldScrollClosure?(scrollView, supposedPage) == true else {
            scrollView.contentOffset.x = CGFloat(supposedPage) * referenceChildSize.width
            return
        }
        
        scrollCallback(.didScroll, scrollView)
        
        if settings.shouldFadePages {
            fadePage(in: scrollView)
        }
        
        let page = Int(round(getCurrentPosition(in: scrollView)))
        eventClosure?(.didChangePosition(currentPage: page))
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let nextChildIndex = currentChildIndex + (scrollView.velocity().x > 0 ? -1 : 1)
        insertChildViewIfNeeded(at: nextChildIndex)
        scrollCallback(.willBeginDragging, scrollView)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        scrollCallback(.willEndDragging(velocity: velocity, targetContentOffset: targetContentOffset), scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollCallback(.didEndDragging(willDecelerate: decelerate), scrollView)
        if !decelerate { scrollViewDidEndScrolling(scrollView) }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollCallback(.didEndDecelerating, scrollView)
        scrollViewDidEndScrolling(scrollView)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollCallback(.didEndScrollingAnimation, scrollView)
        scrollViewDidEndScrolling(scrollView)
    }
    
    private func scrollViewDidEndScrolling(_ scrollView: UIScrollView) {
        
        if let child = currentChildViewController, !isChildVisible(child) {
            (child as? ContainerChildDelegate)?.didLeaveVisibleBounds(of: self)
        }
        
        // Switch to New child
        let index = supposedPage
        if let nextChild = _viewControllers[safe: index], currentChildIndex != index {
            currentChildIndex = index
            insertChildViewIfNeeded(at: index)
            
            if isChildVisible(nextChild) {
                (nextChild as? ContainerChildDelegate)?.didBecomeVisible(in: self)
            }
            
            eventClosure?(.didChangeChild(currentPage: index))
        }
    }
}
