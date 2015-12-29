//
//  Kanji.swift
//  StrokeDrawingView
//
//  Created by Andriy K. on 12/4/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import UIKit
import KanjiBezierPaths

class Kanji {
  
  let color0 = UIColor(red:0.95, green:0, blue:0.63, alpha:1)
  
  let bezierPathes: [UIBezierPath]
  let kanji: String
  
  init(kanji: String) {
    self.kanji = kanji
    self.bezierPathes = KanjiBezierPathesHelper.pathesForKanji(kanji) ?? [UIBezierPath]()
  }
  
}


extension UIColor {
  
  func lighter(amount : CGFloat = 0.25) -> UIColor {
    return hueColorWithBrightnessAmount(1 + amount)
  }
  
  func darker(amount : CGFloat = 0.25) -> UIColor {
    return hueColorWithBrightnessAmount(1 - amount)
  }
  
  private func hueColorWithBrightnessAmount(amount: CGFloat) -> UIColor {
    var hue         : CGFloat = 0
    var saturation  : CGFloat = 0
    var brightness  : CGFloat = 0
    var alpha       : CGFloat = 0
    
    if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
      return UIColor( hue: hue,
        saturation: saturation,
        brightness: brightness * amount,
        alpha: alpha )
    } else {
      return self
    }
    
  }
  
}
