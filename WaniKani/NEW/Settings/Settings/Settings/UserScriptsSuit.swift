//
//  UserScriptsSuit.swift
//  
//
//  Created by Andriy K. on 9/9/15.
//
//

import UIKit

public enum WebSessionType {
  case Lesson
  case Review
  
  var url: String {
    switch self {
      case .Lesson: return "https://www.wanikani.com/lesson/session"
      case .Review: return "https://www.wanikani.com/review/session"
    }
  }
  
}

class UserScriptsSuit: NSObject {
  
//  static let sharedInstance = UserScriptsSuit()
//  
//  // Keys
//  static let fastForwardEnabledKey = "fastForwardEnabledKey"
//  static let ignoreButtonEnabledKey = "ignoreButtonEnabledKey"
//  static let smartResizingEnabledKey = "smartResizingEnabledKey"
//  static let hideStatusBarKey = "hideStatusBarKey"
//  
//  // Scripts
//  private(set) var fastForwardScript = UserScript(filename: "fast_forward", scriptName: "Fast forward")
//  private(set) var ignoreButtonScript = UserScript(filename: "ignore", scriptName: "Ignore button")
//  private(set) var smartResizingScript = UserScript(filename: "resize", scriptName: "Resize")
//  
//  
//  // Flags
//  var fastForwardEnabled = NSUserDefaults.standardUserDefaults().boolForKey(UserScriptsSuit.fastForwardEnabledKey) {
//    didSet {
//      if fastForwardEnabled != oldValue {
//        NSUserDefaults.standardUserDefaults().setBool(fastForwardEnabled, forKey: UserScriptsSuit.fastForwardEnabledKey)
//        NSUserDefaults.standardUserDefaults().synchronize()
//      }
//    }
//  }
//  var ignoreButtonEnabled = NSUserDefaults.standardUserDefaults().boolForKey(UserScriptsSuit.ignoreButtonEnabledKey) {
//    didSet {
//      if ignoreButtonEnabled != oldValue {
//        NSUserDefaults.standardUserDefaults().setBool(ignoreButtonEnabled, forKey: UserScriptsSuit.ignoreButtonEnabledKey)
//        NSUserDefaults.standardUserDefaults().synchronize()
//      }
//    }
//  }
//  var smartResizingEnabled = NSUserDefaults.standardUserDefaults().boolForKey(UserScriptsSuit.smartResizingEnabledKey) {
//    didSet {
//      if smartResizingEnabled != oldValue {
//        NSUserDefaults.standardUserDefaults().setBool(smartResizingEnabled, forKey: UserScriptsSuit.smartResizingEnabledKey)
//        NSUserDefaults.standardUserDefaults().synchronize()
//      }
//    }
//  }
//  
//  var hideStatusBarEnabled = NSUserDefaults.standardUserDefaults().boolForKey(UserScriptsSuit.hideStatusBarKey) {
//    didSet {
//      if hideStatusBarEnabled != oldValue {
//        NSUserDefaults.standardUserDefaults().setBool(hideStatusBarEnabled, forKey: UserScriptsSuit.hideStatusBarKey)
//        NSUserDefaults.standardUserDefaults().synchronize()
//      }
//    }
//  }
//  
//  var userScriptsForReview: [UserScript] {
//    var scripts = [UserScript]()
//    if fastForwardEnabled == true {
//      scripts.append(fastForwardScript)
//    }
//    if ignoreButtonEnabled == true {
//      scripts.append(ignoreButtonScript)
//    }
//    if smartResizingEnabled == true {
//      
//      var resizingScriptCopy = smartResizingScript
//      resizingScriptCopy.modifyScript({ (script) -> (String) in
//        
//        let metrics = optimalReviewMetrics(self.hideStatusBarEnabled)
//        
//        var s = script.stringByReplacingOccurrencesOfString("HHH", withString: "\(metrics.height)")
//        s = s.stringByReplacingOccurrencesOfString("WWW", withString: "\(metrics.width)")
//        s = s.stringByReplacingOccurrencesOfString("FFF", withString: "\(metrics.scale)")
//        
//        return s
//      })
//      scripts.append(resizingScriptCopy)
//    }
//    return scripts
//  }
//  
//  func applyUserScriptsToWebView(webView: UIWebView, type: WebSessionType) {
//    
//    var scripts = [UserScript]()
//    switch type {
//      case .Review: scripts = userScriptsForReview
//      case .Lesson: break
//    }
//    
//    for script in scripts {
//      webView.stringByEvaluatingJavaScriptFromString(script.script)
//    }
//  }
}
