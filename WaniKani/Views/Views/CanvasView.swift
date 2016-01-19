//
//  CanvasView.swift
//  WaniKani
//
//  Created by Andriy K. on 1/19/16.
//  Copyright © 2016 Andriy K. All rights reserved.
//

import UIKit

class CanvasView: UIView {
  
  var char: String?
  let padding: CGFloat = 0.1
  
  var effectiveRect: CGRect {
    let rect = CGRect(x: padding * bounds.width, y: padding * bounds.height, width: bounds.width * (1 - 2 * padding), height: bounds.height * (1 - 2 * padding))
    return rect
  }
  
  override func drawRect(rect: CGRect) {
    
    let strokeColor = UIColor(red:0.92, green:0.12, blue:0.39, alpha:1)
    
    
    let circle = UIBezierPath(ovalInRect: effectiveRect)
    UIColor.whiteColor().setFill()
    circle.fill()
    circle.lineWidth = 5
    strokeColor.setStroke()
    circle.stroke()
    
    if let char = char {
      
      let font = UIFont(name: "Menlo", size: 90)!
      let paddingH: CGFloat = 0.26
      let paddingV: CGFloat = 0.20
      
      let multipleAttributes: [String : AnyObject] = [
        NSFontAttributeName : font,
        NSForegroundColorAttributeName : strokeColor
      ]
      
      char.drawInRect(CGRect(x: paddingH * bounds.width, y: paddingV * bounds.height, width: bounds.width, height: bounds.height), withAttributes: multipleAttributes)
    }
  }
}

extension CanvasView {
  
  func pb_takeSnapshot() -> UIImage {
    UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.mainScreen().scale)
    
    _ = 4
    layer.renderInContext(UIGraphicsGetCurrentContext()!)
    let originalImg = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return originalImg
  }
}
