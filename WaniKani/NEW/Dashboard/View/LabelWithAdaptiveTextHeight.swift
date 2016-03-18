//
//  LabelWithAdaptiveTextHeight.swift
//  WaniKani
//
//  Created by Andriy K. on 3/18/16.
//  Copyright © 2016 Andriy K. All rights reserved.
//

import Foundation
import UIKit

class LabelWithAdaptiveTextHeight: UILabel {
  
  var heightKoefitient: CGFloat = 1.0
  
  override func layoutSubviews() {
    super.layoutSubviews()
    font = fontToFitHeight()
  }
  
  // Returns an UIFont that fits the new label's height.
  private func fontToFitHeight() -> UIFont {
    
    var minFontSize: CGFloat = 4 // CGFloat 18
    var maxFontSize: CGFloat = 67     // CGFloat 67
    var fontSizeAverage: CGFloat = 0
    var textAndLabelHeightDiff: CGFloat = 0
    
    while (minFontSize <= maxFontSize) {
      fontSizeAverage = minFontSize + (maxFontSize - minFontSize) / 2
      
      if let labelText: NSString = text {
        let labelHeight = frame.size.height * heightKoefitient
        
        let testStringHeight = labelText.sizeWithAttributes(
          [NSFontAttributeName: font.fontWithSize(fontSizeAverage)]
          ).height
        
        textAndLabelHeightDiff = labelHeight - testStringHeight
        
        if (fontSizeAverage == minFontSize || fontSizeAverage == maxFontSize) {
          if (textAndLabelHeightDiff < 0) {
            return font.fontWithSize(fontSizeAverage - 1)
          }
          return font.fontWithSize(fontSizeAverage)
        }
        
        if (textAndLabelHeightDiff < 0) {
          maxFontSize = fontSizeAverage - 1
          
        } else if (textAndLabelHeightDiff > 0) {
          minFontSize = fontSizeAverage + 1
          
        } else {
          return font.fontWithSize(fontSizeAverage)
        }
      } else {
        break
      }
    }
    return font.fontWithSize(fontSizeAverage)
  }
  
}
