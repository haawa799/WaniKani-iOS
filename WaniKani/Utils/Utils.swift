//
//  Utils.swift
//  
//
//  Created by Andriy K. on 8/25/15.
//
//

import UIKit

let hideSubscribitionsSkript = "$('a[href=\"/account/subscription\"]').hide();"

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

func optimalReviewMetrics(statusBarHidden: Bool) -> (height: Int, width: Int, scale: Int) {
  let screenSize: CGRect = UIScreen.mainScreen().bounds
  var height = Int(screenSize.height - 154)
  var scale = 100
  if statusBarHidden == true {
    height += 20
  }
  let width = Int(screenSize.width)
  
  let model = PhoneModel.myModel()
  
  switch model {
  case .iPhone6Plus :
    height -= 271
    scale = 250
  case .iPhone6 :
     height -= 258
     scale = 250
  case .iPhone5 :
     height -= 253
     scale = 220
  case .iPhone4 :
     height = 50
     scale = 100
  }
  
  return (height, width, scale)
}


enum PhoneModel {
  case iPhone4
  case iPhone5
  case iPhone6
  case iPhone6Plus
  
  static func myModel() -> PhoneModel {
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    switch screenSize.height {
    case 736 :
      return .iPhone6Plus
    case 667 :
      return .iPhone6
    case 568 :
      return .iPhone5
    case 480 :
      return iPhone4
    default : return iPhone6
    }
  }
}
