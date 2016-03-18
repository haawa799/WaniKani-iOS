//
//  DrawingUtils.swift
//  WaniKani
//
//  Created by Andriy K. on 3/17/16.
//  Copyright © 2016 Andriy K. All rights reserved.
//

import UIKit

extension CGRect {
  var center: CGPoint {
    return CGPoint(x: CGRectGetMidX(self), y: CGRectGetMidY(self))
  }
}
