//
//  BackgroundLayer.swift
//  Pods
//
//  Created by Andriy K. on 12/28/15.
//
//

import UIKit

class BackgroundLayer: CALayer {
  
  var strokes: [UIBezierPath]?
  
  var strokeColor = UIColor(red: 119/255, green: 119/255, blue: 119/255, alpha: 0.5)
  
  override init() {
    super.init()
    self.delegate = self
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.delegate = self
  }
  
  override init(layer: AnyObject) {
    super.init(layer: layer)
    self.delegate = self
  }
  
  override func drawInContext(ctx: CGContext) {
    super.drawInContext(ctx)
    
    guard let strokes = strokes else { return }
    
    for stroke in strokes {
      CGContextSetStrokeColorWithColor(ctx, strokeColor.CGColor)
      CGContextSetLineWidth(ctx, stroke.lineWidth - 1)
      CGContextAddPath(ctx, stroke.CGPath)
      CGContextDrawPath(ctx, .Stroke)
    }
    
  }
  
}
