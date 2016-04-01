//
//  SideMenuContainerController.swift
//  WaniKani
//
//  Created by Andriy K. on 1/5/16.
//  Copyright © 2016 Andriy K. All rights reserved.
//

import UIKit

class SideMenuContainerController: UIViewController {
  
  var webViewData: WebViewData? {
    didSet {
      setWebDataIfNeeded()
    }
  }
  var sideMenuController: SideMenuViewController? {
    didSet {
      setWebDataIfNeeded()
    }
  }
  
  func setWebDataIfNeeded() {
    guard let sideMenuController = sideMenuController ,let webViewData = webViewData where sideMenuController.webViewData == nil else { return }
    
    sideMenuController.webViewData = webViewData
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    super.prepareForSegue(segue, sender: sender)
    
    if let vc = segue.destinationViewController as? SideMenuViewController {
      self.sideMenuController = vc
    }
  }
  
  override func prefersStatusBarHidden() -> Bool {
    return SettingsSuit.sharedInstance.hideStatusBarEnabled
  }
  
}
