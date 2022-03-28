//
//  LineView.swift
//  VFPoC
//
//  Created by Sergey Gorin on 15/02/2019.
//  Copyright © 2019 Sergey Gorin. All rights reserved.
//

import UIKit

class LineView: UIView {
    
    enum Axis {
        case horizontal, vertical
    }
    
    var axis: Axis = .horizontal
    var isDashed: Bool = false
    
    var lineColor: UIColor = .black
    var lineWidth: CGFloat = 1.0
    
    init(axis: Axis = .horizontal,
         dashed: Bool = false,
         lineColor: UIColor = .black,
         lineWidth: CGFloat = 1.0) {
        
        super.init(frame: .zero)
        commonInit()
        self.axis = axis
        self.isDashed = dashed
        self.lineColor = lineColor
        self.lineWidth = lineWidth
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func update() {
        setNeedsDisplay()
    }
    
    private func commonInit() {
        backgroundColor = .clear
        clearsContextBeforeDrawing = false
    }
    
    override func layoutSubviews() {
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        path.lineWidth = lineWidth
        
        switch axis {
        case .horizontal:
            
            let endX = rect.size.width
                - (rect.size.width.truncatingRemainder(dividingBy: lineWidth * 2))
                + lineWidth
            let startX = (rect.size.width - endX).half + lineWidth
            let centerY = rect.height.half
            
            path.move(to: CGPoint(x: startX, y: centerY))
            path.addLine(to: CGPoint(x: endX, y: centerY))
            
        case .vertical:
            
            let endY = rect.size.height
                - (rect.size.height.truncatingRemainder(dividingBy: lineWidth * 2))
                + lineWidth
            let startY = (rect.size.height - endY).half + lineWidth
            let centerX = rect.width.half
            
            path.move(to: CGPoint(x: centerX, y: startY))
            path.addLine(to: CGPoint(x: centerX, y: endY))
        }
        
        if isDashed {
            let dashes: [CGFloat] = [lineWidth, lineWidth]
            path.setLineDash(dashes, count: dashes.count, phase: 0)
            path.lineCapStyle = .butt
        }
        
        lineColor.setStroke()
        
        path.stroke()
    }
}
