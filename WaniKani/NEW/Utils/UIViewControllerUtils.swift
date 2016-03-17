//✅
//  UIViewControllerUtils.swift
//  WaniKani
//
//  Created by Andriy K. on 3/14/16.
//  Copyright © 2016 Andriy K. All rights reserved.
//

import UIKit

protocol StoryboardInstantiable: NSObjectProtocol {
  static func instantiateViewController<T>(bundle: NSBundle?) -> T
}

extension StoryboardInstantiable where Self: UIViewController {

  static func instantiateViewController<T>(bundle: NSBundle? = nil) -> T {
    
    guard let fileName = NSStringFromClass(Self).componentsSeparatedByString(".").last else {
      fatalError("Coudn't find storyboard")
    }
    
    let sb = UIStoryboard(name: fileName, bundle: bundle)
    return sb.instantiateInitialViewController() as! T
  }
  
}
