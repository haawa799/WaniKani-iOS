//
//  ColorUtils.swift
//  WaniKani
//
//  Created by Andriy K. on 3/22/16.
//  Copyright © 2016 Andriy K. All rights reserved.
//

import UIKit

extension UIColor {
  static func colorForPowerLevel(powerLevel: CGFloat) -> UIColor {
    let power = max(powerLevel, 0.3)
    let c = UIColor(red: power, green: (1 - power), blue: 0, alpha: 1.0)
    return c
  }
}
