//
//  Utils.swift
//  
//
//  Created by Andriy K. on 8/25/15.
//
//

import UIKit

func delay(delay:Double, closure:()->()) {
  dispatch_after(
    dispatch_time(
      DISPATCH_TIME_NOW,
      Int64(delay * Double(NSEC_PER_SEC))
    ),
    dispatch_get_main_queue(), closure)
}
