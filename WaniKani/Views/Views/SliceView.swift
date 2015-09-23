//
//  SliceView.swift
//  WaniKani
//
//  Created by Andriy K. on 9/23/15.
//  Copyright © 2015 Andriy K. All rights reserved.
//

import UIKit

class SliceView: UIView {
  
  private var path: UIBezierPath!
  
  private func recalculateMask(){
    
    let p0 = CGPoint(x: bounds.width, y: 0)
    let p1 = CGPoint(x: bounds.width, y: bounds.height)
    let p2 = CGPoint(x: 0, y: bounds.height)
    let points = [p0, p1, p2]
    
    let p = CGPathCreateMutable()
    if points.count > 0 {
      let point = points.first!
      CGPathMoveToPoint(p, nil, point.x, point.y)
      for var i = 1; i < points.count; i++ {
        let point = points[i]
        CGPathAddLineToPoint(p, nil, point.x, point.y)
      }
    }
    path = UIBezierPath(CGPath: p)
  }
  
  override func drawRect(rect: CGRect) {
    UIColor.whiteColor().setStroke()
    path.lineWidth = 0
    path.stroke()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    recalculateMask()
    
    let mask = CAShapeLayer()
    mask.frame = bounds
    mask.path = path.CGPath
    layer.mask = mask
  }
  
}
