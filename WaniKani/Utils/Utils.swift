//
//  Utils.swift
//
//
//  Created by Andriy K. on 8/25/15.
//
//

import UIKit
import Device

let hideSubscribitionsSkript = "$('a[href=\"/account/subscription\"]').remove();document.getElementsByClassName('upgrade')[0].remove();document.getElementsByClassName('newbie')[0].remove();"

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
  static var nibName: String {get}
}

extension SingleReuseIdentifier where Self: UICollectionReusableView {
  static var identifier: String {
    return NSStringFromClass(Self).componentsSeparatedByString(".").last ?? ""
  }
  static var nibName: String {
    return identifier
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
  
  let model = Device.size()
  
  var keyboardHeight = 0
  switch model {
  case .Screen5_5Inch :
    keyboardHeight = 271
    height -= keyboardHeight
    scale = 250
  case .Screen4_7Inch :
    keyboardHeight = 258
    height -= keyboardHeight
    scale = 250
  case .Screen4Inch :
    keyboardHeight = 258
    height -= keyboardHeight
    scale = 220
  case .Screen3_5Inch :
    height = 50
    scale = 100
  case .Screen7_9Inch, .Screen9_7Inch, .Screen12_9Inch:
    
    if UIDevice.currentDevice().orientation == .Portrait {
      keyboardHeight = 350
    } else {
      keyboardHeight = 455
    }
    height -= keyboardHeight
    scale = 100
    
  case .UnknownSize:
    break
  }
  
  return (height, width, scale)
}

extension UIView {
  class func fromNib<T : UIView>(nibNameOrNil: String? = nil) -> T {
    let v: T? = fromNib(nibNameOrNil)
    return v!
  }
  
  class func fromNib<T : UIView>(nibNameOrNil: String? = nil) -> T? {
    var view: T?
    let name: String
    if let nibName = nibNameOrNil {
      name = nibName
    } else {
      // Most nibs are demangled by practice, if not, just declare string explicitly
      name = "\(T.self)".componentsSeparatedByString(".").last!
    }
    let nibViews = NSBundle.mainBundle().loadNibNamed(name, owner: nil, options: nil)
    for v in nibViews {
      if let tog = v as? T {
        view = tog
      }
    }
    return view
  }
}

