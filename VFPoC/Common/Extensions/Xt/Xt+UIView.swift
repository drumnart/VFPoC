//
//  Xt+UIView.swift
//  MoneyMaker
//
//  Created by Sergey Gorin on 03/12/2018.
//  Copyright © 2018 Sergey Gorin. All rights reserved.
//

import UIKit

extension UIView: XtCompatible {}

extension Xt where Base: UIView {
    
    /// Checks if any animation is in progress
    var isAnimating: Bool {
        guard let animationKeys = base.layer.animationKeys() else {
            return false
        }
        return animationKeys.count > 0
    }
    
    /// Status bar height for convinience
    var statusBarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.height
    }
    
    /// Returns optimal size for self
    var layoutFittingSize: CGSize {
        return base.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
    
    /// Add several subviews to view at once
    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach { base.addSubview($0) }
    }
    
    /// Add several subviews to view at once
    func addSubviews(_ subviews: UIView...) {
        subviews.forEach { base.addSubview($0) }
    }
    
    /// Checks view's visibility in the given view or in it's superview if parameter 'view' is nil
    func isVisible(in view: UIView? = nil) -> Bool {
        guard base.alpha > 0 && !base.isHidden else { return false }
        guard let view = view ?? base.superview else { return true }
        
        let frame = view.convert(base.bounds, from: base)
        if frame.intersects(view.bounds) {
            return view.xt.isVisible(in: view.superview)
        }
        return false
    }
    
    func getSubview(withId id: String) -> UIView? {
        if base.accessibilityIdentifier == id { return base }
        for subview in base.subviews {
            if let result = subview.xt.getSubview(withId: id) { return result }
        }
        return nil
    }
    
    func setId(_ id: String) {
        base.accessibilityIdentifier = id
    }
    
    func visibleRect(in view: UIView? = nil) -> CGRect {
        guard base.alpha > 0 && !base.isHidden else { return .zero }
        guard let view = view ?? base.superview else { return base.frame }
        
        let frame = view.convert(base.bounds, from: base)
        return frame.intersection(view.bounds)
    }
    
    /// Improve drawing performance
    func rasterize(opaqued: Bool = true) {
        base.layer.shouldRasterize = true
        base.layer.rasterizationScale = UIScreen.main.scale
        base.isOpaque = opaqued
    }
    
    /// Make round corners
    func round(borderWidth: CGFloat = 0.0,
               borderColor: UIColor = .clear,
               cornerRadius: CGFloat = 0) {
        base.layer.cornerRadius = cornerRadius > 0 ? cornerRadius : base.frame.height * 0.5
        base.layer.borderColor = borderColor.cgColor
        base.layer.borderWidth = borderWidth
        base.layer.masksToBounds = true
    }
    
    /// Adds gradient sublayer
    @discardableResult
    func addGradient(inRect bounds: CGRect? = nil,
                     at index: Int = 0,
                     colors: [UIColor] = [.black, .clear],
                     startPoint: CGPoint = CGPoint(x: 0.5, y: 0.0),
                     endPoint: CGPoint = CGPoint(x: 0.5, y: 1.0),
                     locations: [NSNumber]? = nil) -> CALayer {
        return CAGradientLayer().with {
            $0.frame = bounds ?? base.bounds
            $0.colors = colors.map { $0.cgColor }
            $0.startPoint = startPoint
            $0.endPoint = endPoint
            $0.locations = locations
            base.layer.insertSublayer($0, at: 0)
        }
    }
    
    /// Sets shadow parameters to the view's layer
    func addShadow(opacity: Float = 0.0,
                   offset: CGSize = CGSize(width: 0.0, height: 2.0),
                   radius: CGFloat = 3.0,
                   color: UIColor = .black,
                   bounds: CGRect? = nil,
                   shouldRasterize: Bool = false) {
        base.layoutIfNeeded()
        base.layer.shadowOpacity = opacity
        base.layer.shadowOffset = offset
        base.layer.shadowRadius = radius
        base.layer.shadowColor = color.cgColor
        base.layer.shadowPath = UIBezierPath(
            roundedRect: bounds ?? base.bounds,
            cornerRadius: base.layer.cornerRadius
        ).cgPath
        base.layer.shouldRasterize = shouldRasterize
        base.layer.masksToBounds = false
    }
    
    func hideShadow() {
        base.layer.shadowOpacity = 0.0
    }
    
    func chunkSize(maxWidth: CGFloat? = nil,
                   interItemSpacing: CGFloat = 0.0,
                   margins: UIEdgeInsets = .zero,
                   maxItemsPerRow: Int = 2,
                   minRatio: CGFloat = 1.0,
                   multipliers: (x: Int, y: Int) = (1, 1)) -> CGSize {
        let maxWidth = maxWidth ?? base.frame.width
        let maxItemsPerRow = maxItemsPerRow > 0 ? maxItemsPerRow : 1
        let spacing = interItemSpacing * CGFloat(maxItemsPerRow - 1)
        let minWidth = (maxWidth - spacing - margins.leftRight) / CGFloat(maxItemsPerRow)
        let minHeight = minWidth * minRatio
        let mult: (x: CGFloat, y: CGFloat) = (CGFloat(multipliers.x), CGFloat(multipliers.y))
        return CGSize(width: floor(minWidth * mult.x + interItemSpacing * (mult.x - 1)),
                      height: floor(minHeight * mult.y + interItemSpacing * (mult.y - 1)))
    }
}

// MARK: Layout Constraints configuring helpers

extension Xt where Base: UIView {
    
    /// Dimensions & Anchors
    
    var width: NSLayoutDimension {
        return base.widthAnchor
    }
    
    var height: NSLayoutDimension {
        return base.heightAnchor
    }
    
    var top: NSLayoutYAxisAnchor {
        return base.topAnchor
    }
    
    var bottom: NSLayoutYAxisAnchor {
        return base.bottomAnchor
    }
    
    var leading: NSLayoutXAxisAnchor {
        return base.leadingAnchor
    }
    
    var trailing: NSLayoutXAxisAnchor {
        return base.trailingAnchor
    }
    
    var centerX: NSLayoutXAxisAnchor {
        return base.centerXAnchor
    }
    
    var centerY: NSLayoutYAxisAnchor {
        return base.centerYAnchor
    }
    
    var center: (NSLayoutXAxisAnchor, NSLayoutYAxisAnchor) {
        return (base.centerXAnchor, base.centerYAnchor)
    }
    
    /// Activators & Deactivators
    
    @discardableResult
    func activate(constraint: NSLayoutConstraint) -> NSLayoutConstraint {
        return constraint.xt.activate()
    }
    
    func activate(constraints: [NSLayoutConstraint]) {
        NSLayoutConstraint.xt.activate(constraints)
    }
    
    func activate(constraints: NSLayoutConstraint...) {
        activate(constraints: constraints)
    }
    
    func deactivate(constraints: [NSLayoutConstraint]) {
        NSLayoutConstraint.deactivate(constraints)
    }
    
    func deactivate(constraints: NSLayoutConstraint...) {
        deactivate(constraints: constraints)
    }
    
    /// Constraining & Layouting
    
    @discardableResult
    func applyConstraints(_ closure: (UIView) -> [NSLayoutConstraint]) -> Self {
        activate(constraints: closure(base))
        return self
    }
    
    @discardableResult
    func width(_ w: CGFloat) -> NSLayoutConstraint {
        return base.widthAnchor.constraint(equalToConstant: w).xt.activate()
    }
    
    @discardableResult
    func width(equalTo view: UIView,
               multiplier: CGFloat = 1.0,
               constant: CGFloat = 0.0) -> NSLayoutConstraint {
        return width(equalTo: view.widthAnchor, multiplier: multiplier, constant: constant)
    }
    
    @discardableResult
    func width(equalTo dimension: NSLayoutDimension,
               multiplier: CGFloat = 1.0,
               constant: CGFloat = 0.0) -> NSLayoutConstraint {
        return base.widthAnchor.constraint(
                equalTo: dimension,
                multiplier: multiplier,
                constant: constant
        ).xt.activate()
    }
    
    @discardableResult
    func height(_ h: CGFloat) -> NSLayoutConstraint {
        return base.heightAnchor.constraint(equalToConstant: h).xt.activate()
    }
    
    @discardableResult
    func height(equalTo view: UIView,
                multiplier: CGFloat = 1.0,
                constant: CGFloat = 0.0) -> NSLayoutConstraint {
        return height(equalTo: view.heightAnchor, multiplier: multiplier, constant: constant)
    }
    
    @discardableResult
    func height(equalTo dimension: NSLayoutDimension,
                multiplier: CGFloat = 1.0,
                constant: CGFloat = 0.0) -> NSLayoutConstraint {
            return base.heightAnchor.constraint(
                equalTo: dimension,
                multiplier: multiplier,
                constant: constant
            ).xt.activate()
    }
    
    func size(_ size: CGSize) {
        width(size.width)
        height(size.height)
    }
    
    func size(w: CGFloat, h: CGFloat) {
        width(w)
        height(h)
    }
    
    func size(equalTo view: UIView, multipliers: CGPoint = CGPoint(x: 1.0, y: 1.0)) {
        width(equalTo: view, multiplier: multipliers.x)
        height(equalTo: view, multiplier: multipliers.y)
    }
    
    /// If parameter view equals nil than the superview is used as another view
    func attachEdges(_ edges: UIRectEdge = .all,
                     to view: UIView? = nil,
                     insets: UIEdgeInsets = .zero) {
        
        guard let anotherView = view ?? base.superview else { return }
        
        var constraints: [NSLayoutConstraint] = []
        
        if edges.contains(.top) {
            constraints.append(base.topAnchor.constraint(
                equalTo: anotherView.topAnchor,
                constant: insets.top
            ))
        }
        if edges.contains(.bottom) {
            constraints.append(base.bottomAnchor.constraint(
                equalTo: anotherView.bottomAnchor,
                constant: -insets.bottom
            ))
        }
        if edges.contains(.left) {
            constraints.append(base.leftAnchor.constraint(
                equalTo: anotherView.leftAnchor,
                constant: insets.left
            ))
        }
        if edges.contains(.right) {
            constraints.append(base.rightAnchor.constraint(
                equalTo: anotherView.rightAnchor,
                constant: -insets.right
            ))
        }
        
        activate(constraints: constraints)
    }
    
    @discardableResult
    func top(_ constant: CGFloat = 0.0, to anchor: NSLayoutYAxisAnchor) -> NSLayoutConstraint {
        return base.topAnchor.constraint(equalTo: anchor, constant: constant).xt.activate()
    }
    
    @discardableResult
    func bottom(_ constant: CGFloat = 0.0, to anchor: NSLayoutYAxisAnchor) -> NSLayoutConstraint {
        return base.bottomAnchor.constraint(equalTo: anchor, constant: constant).xt.activate()
    }
    
    @discardableResult
    func leading(_ constant: CGFloat = 0.0, to anchor: NSLayoutXAxisAnchor) -> NSLayoutConstraint {
        return base.leadingAnchor.constraint(equalTo: anchor, constant: constant).xt.activate()
    }
    
    @discardableResult
    func trailing(_ constant: CGFloat = 0.0, to anchor: NSLayoutXAxisAnchor) -> NSLayoutConstraint{
        return base.trailingAnchor.constraint(equalTo: anchor, constant: constant).xt.activate()
    }
    
    func centerX(equalTo view: UIView, constant: CGFloat = 0.0) {
        activate(constraints:
            base.centerXAnchor.constraint(equalTo: view.centerXAnchor,
                                          constant: constant)
        )
    }
    
    func centerY(equalTo view: UIView, constant: CGFloat = 0.0) {
        activate(constraints:
            base.centerYAnchor.constraint(equalTo: view.centerYAnchor,
                                          constant: constant)
        )
    }
    
    func center(equalTo view: UIView, offset: CGPoint = CGPoint(x: 0.0, y: 0.0)) {
        centerX(equalTo: view, constant: offset.x)
        centerY(equalTo: view, constant: offset.y)
    }
    
    @discardableResult
    func layout(_ subview: UIView, closure: (_ child: Xt<UIView>) -> Void) -> Self {
        base.addSubview(subview)
        closure(subview.xt)
        return self
    }
    
    @discardableResult
    func layout(in superview: UIView? = nil, closure: (Xt<Base>) -> Void) -> Self {
        (superview ?? base.superview)?.addSubview(base)
        closure(self)
        return self
    }
    
    @discardableResult
    func layout(in superview: UIView? = nil, closure: (_ base: Xt<Base>, _ superview: UIView) -> Void) -> Self {
        guard let sv = (superview ?? base.superview) else {
            return self
        }
        sv.addSubview(base)
        closure(self, sv)
        return self
    }
    
    @discardableResult
    func layout(_ closure: (_ base: Xt<Base>, _ superview: UIView) -> Void) -> Self {
        return layout(in: base.superview, closure: closure)
    }
}
