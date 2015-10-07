//
//  DoubleProgressBar.swift
//  WaniKani
//
//  Created by Andriy K. on 9/29/15.
//  Copyright © 2015 Andriy K. All rights reserved.
//

import UIKit

@IBDesignable
class DoubleProgressBar: UIControl {
  
  @IBInspectable var topColor = UIColor(red:0.92, green:0.12, blue:0.39, alpha:1) {
    didSet {
      setNeedsDisplay()
    }
  }
  
  @IBInspectable var botColor = UIColor(red:0, green:0.64, blue:0.96, alpha:1)  {
    didSet {
      setNeedsDisplay()
    }
  }
  
  @IBInspectable var grayColor = UIColor(red:0.7, green:0.7, blue:0.7, alpha:0.3) {
    didSet {
      setNeedsDisplay()
    }
  }
  
  private var oldTopProgress: CGFloat = 0.0
  @IBInspectable var topProgress: CGFloat = 0.0 {
    didSet {
      oldTopProgress = oldValue
      setNeedsDisplay()
    }
  }
  
  private var oldBotProgress: CGFloat = 0.0
  @IBInspectable var botProgress: CGFloat = 0.0 {
    didSet {
      oldBotProgress = oldValue
      print(botProgress)
      setNeedsDisplay()
    }
  }
  
  private var bottomPath: UIBezierPath!
  private var topPath: UIBezierPath!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    recalculatePathes()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    recalculatePathes()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    recalculatePathes()
    setNeedsDisplay()
  }
  
  private var topLayer: CAShapeLayer?
  private var botLayer: CAShapeLayer?
  var circleContentView: UIView!
  
  private func recalculatePathes() {
    
    if topLayer == nil {
      topLayer = CAShapeLayer()
      layer.addSublayer(topLayer!)
    }
    if botLayer == nil {
      botLayer = CAShapeLayer()
      layer.addSublayer(botLayer!)
    }
    if circleContentView == nil {
      circleContentView = UIView(frame: CGRectZero)
      circleContentView.backgroundColor = UIColor.clearColor()
      addSubview(circleContentView)
    }
    
    
    let kof: CGFloat = 0.9
    
    let usualHeight = bounds.height * 0.75
    let maxHeight = bounds.width * 0.2
    let maxDelta: CGFloat = 15.0
    
    let height = min(usualHeight, maxHeight)
    let delta: CGFloat = min(maxDelta, (bounds.height - usualHeight) * 0.5)//(bounds.height - bounds.height * 0.75) * 0.5
    let radius = height * 0.5
    
    let alpha = CGFloat(M_PI) * kof
    
    let k = radius * cos(alpha)
    let q = radius * sin(alpha)
    
    let rightSquare = CGRect(x: bounds.width - height - delta, y: delta, width: height, height: height)
    circleContentView.frame = rightSquare
    // Bottom path
    do {
      let endpoint = CGPoint(x: rightSquare.center.x - k, y: rightSquare.center.y + q)
      let farLeftPoint = CGPoint(x: delta, y: endpoint.y)
      bottomPath = UIBezierPath(arcCenter: rightSquare.center, radius: radius, startAngle: 0.0, endAngle: alpha, clockwise: true)
      bottomPath.addLineToPoint(farLeftPoint)
    }
    
    do {
      let a = CGFloat(M_PI) * (2 - kof)
      let endpoint = CGPoint(x: rightSquare.center.x - k, y: rightSquare.center.y - q)
      let farLeftPoint = CGPoint(x: delta, y: endpoint.y)
      topPath = UIBezierPath(arcCenter: rightSquare.center, radius: radius, startAngle: 0.0, endAngle: a, clockwise: false)
      topPath.addLineToPoint(farLeftPoint)
      topPath = UIBezierPath.bezierPathByReversingPath(topPath)()//topPath.reve
    }
    
    // Top path
  }
  
  override func drawRect(rect: CGRect) {
    grayColor.setStroke()
    bottomPath.lineWidth = 2.0
    bottomPath.stroke()
    topPath.lineWidth = 2.0
    topPath.stroke()
    topPath.drawInView(bezier: topLayer!, view: self, strokeColor: topColor, lineWidth: 2.0, oldProgress: oldTopProgress, progress: topProgress,animated: true)
    oldTopProgress = topProgress
    bottomPath.drawInView(bezier: botLayer!, view: self, strokeColor: botColor, lineWidth: 2.0, oldProgress: oldBotProgress, progress: botProgress, animated: true)
    oldBotProgress = botProgress
  }
  
}

extension UIBezierPath {
  
  private func drawInView(bezier bezier: CAShapeLayer, view: UIView, strokeColor: UIColor, lineWidth: CGFloat, oldProgress: CGFloat, progress: CGFloat, animated: Bool) {
    
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