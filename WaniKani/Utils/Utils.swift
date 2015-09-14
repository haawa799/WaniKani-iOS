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

extension UIBackgroundFetchResult: Printable {
  public var description: String {
    switch self {
    case .NewData : return "NewData"
    case .NoData : return "NoData"
    case .Failed : return "Failed"
    }
  }
}

