//
//  UserScriptsSuit.swift
//  
//
//  Created by Andriy K. on 9/9/15.
//
//

import UIKit

enum WebSessionType {
  case Lesson
  case Review
}

class UserScriptsSuit: NSObject {
  
  static let sharedInstance = UserScriptsSuit()
  
  // Keys
  static let fastForwardEnabledKey = "fastForwardEnabledKey"
  
  // Scripts
  private var fastForwardScript = UserScript.scriptNamed("fast_forward")!
  
  
  // Flags
  var fastForwardEnabled = NSUserDefaults.standardUserDefaults().boolForKey(UserScriptsSuit.fastForwardEnabledKey) {
    didSet {
      if fastForwardEnabled != oldValue {
        NSUserDefaults.standardUserDefaults().setBool(fastForwardEnabled, forKey: UserScriptsSuit.fastForwardEnabledKey)
        NSUserDefaults.standardUserDefaults().synchronize()
      }
    }
  }
  
  var userScriptsForReview: [UserScript] {
    var scripts = [UserScript]()
    if fastForwardEnabled == true {
      scripts.append(fastForwardScript)
    }
    return scripts
  }
  
  func applyUserScriptsToWebView(webView: UIWebView, type: WebSessionType) {
    
    var scripts = [UserScript]()
    switch type {
      case .Review: scripts = userScriptsForReview
      case .Lesson: break
    }
    
    for script in scripts {
      webView.stringByEvaluatingJavaScriptFromString(script.script)
    }
  }
}
