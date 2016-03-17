//
//  LabelExtensions.swift
//  WaniKani
//
//  Created by Andriy K. on 3/16/16.
//  Copyright © 2016 Andriy K. All rights reserved.
//

import UIKit

extension UILabel{
  
  func adjustFontSizeToFitRect(rect : CGRect){
    
    if text == nil{
      return
    }
    
    frame = rect
    
    let maxFontSize: CGFloat = 100.0
    let minFontSize: CGFloat = 5.0
    
    var q = Int(maxFontSize)
    var p = Int(minFontSize)
    
    let constraintSize = CGSize(width: rect.width, height: CGFloat.max)
    
    while(p <= q){
      let currentSize = (p + q) / 2
      font = font.fontWithSize( CGFloat(currentSize) )
      let text = NSAttributedString(string: self.text!, attributes: [NSFontAttributeName:font])
      let textRect = text.boundingRectWithSize(constraintSize, options: .UsesLineFragmentOrigin, context: nil)
      
      let labelSize = textRect.size
      
      if labelSize.height < frame.height && labelSize.height >= frame.height-10 && labelSize.width < frame.width && labelSize.width >= frame.width-10 {
        break
      }else if labelSize.height > frame.height || labelSize.width > frame.width{
        q = currentSize - 1
      }else{
        p = currentSize + 1
      }
    }
    
  }
}

extension CGRect {
  func centerAndAdjustPercentage(percentage p: CGFloat) -> CGRect {
    let w = self.width
    let h = self.height
    
    let newW = w * p
    let newH = h * p
    let newX = (w - newW) / 2
    let newY = (h - newH) / 2
    
    return CGRect(x: newX, y: newY, width: newW, height: newH)
  }
}