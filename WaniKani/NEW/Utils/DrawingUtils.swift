//
//  DrawingUtils.swift
//  WaniKani
//
//  Created by Andriy K. on 3/17/16.
//  Copyright © 2016 Andriy K. All rights reserved.
//

import UIKit

extension UIBezierPath {
  
  func drawInView(bezier bezier: CAShapeLayer, view: UIView, strokeColor: UIColor, lineWidth: CGFloat, oldProgress: CGFloat, progress: CGFloat, animated: Bool) {
    
    bezier.removeAllAnimations()
    
    bezier.path = self.CGPath
    bezier.strokeColor = strokeColor.CGColor
    bezier.lineWidth = lineWidth
    bezier.strokeStart = 0.0
    bezier.strokeEnd = progress
    bezier.fillColor = nil
    bezier.lineJoin = kCALineJoinBevel
    
    if animated {
      let animateStrokeEnd = CABasicAnimation(keyPath: "strokeEnd")
      animateStrokeEnd.duration = 0
      animateStrokeEnd.fromValue = progress
      animateStrokeEnd.toValue = progress
      bezier.addAnimation(animateStrokeEnd, forKey: "strokeEndAnimation")
    }
  }
}

extension CGRect {
  var center: CGPoint {
    return CGPoint(x: CGRectGetMidX(self), y: CGRectGetMidY(self))
  }
}
