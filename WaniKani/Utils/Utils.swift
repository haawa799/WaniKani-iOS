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

extension UIBackgroundFetchResult: CustomStringConvertible {
  public var description: String {
    switch self {
    case .NewData : return "NewData"
    case .NoData : return "NoData"
    case .Failed : return "Failed"
    }
  }
}

protocol SingleReuseIdentifier {
  static var identifier: String {get}
}

extension SingleReuseIdentifier where Self: UICollectionReusableView {
  static var identifier: String {
    return NSStringFromClass(Self)
  }
}

protocol FlippableView {
  func flip(animations animations: () -> Void, delay: NSTimeInterval)
}

extension FlippableView where Self: UIView {
  func flip(animations animations: () -> Void, delay: NSTimeInterval){
    dispatch_after(
      dispatch_time(
        DISPATCH_TIME_NOW,
        Int64(delay * Double(NSEC_PER_SEC))
      ),
      dispatch_get_main_queue(), {
        UIView.transitionWithView(self, duration: 1.0, options: UIViewAnimationOptions.TransitionFlipFromTop, animations: animations, completion: nil)
    })
  }
}