//
//  SettingsSuit.swift
//  WaniKani
//
//  Created by Andriy K. on 10/7/15.
//  Copyright © 2015 Andriy K. All rights reserved.
//

import UIKit

class Setting {
  let key: String
  let script: UserScript?
  let description: String?
  
  
  var enabled: Bool = false {
    didSet {
      if enabled != oldValue {
        NSUserDefaults.standardUserDefaults().setBool(enabled, forKey: key)
        NSUserDefaults.standardUserDefaults().synchronize()
      }
    }
  }
  
  init(key: String, script: UserScript?, description: String?) {
    self.key = key
    self.description = description
    self.script = script
    self.enabled = NSUserDefaults.standardUserDefaults().boolForKey(key)
  }
}

class SettingsSuit: NSObject {
  
  static let sharedInstance = SettingsSuit()
  
  let settings: [Int: (name: String, settings:[Setting])] = {
    
    // Scripts
    let firstSectionIndex = 0
    var scriptsSettings = [Setting]()
    scriptsSettings.append(Setting(key: fastForwardEnabledKey, script: fastForwardScript, description: fastForwardScript.name))
    scriptsSettings.append(Setting(key: ignoreButtonEnabledKey, script: ignoreButtonScript, description: ignoreButtonScript.name))
    if PhoneModel.myModel() != .iPhone4 {
      scriptsSettings.append(Setting(key: smartResizingEnabledKey, script: smartResizingScript, description: smartResizingScript.name))
    }
    
    
    // Other options
    let othersSectionIndex = 1
    var otherSettings = [Setting]()
    otherSettings.append(Setting(key: hideStatusBarKey, script: nil, description: "Status bar hidden on Reviews"))
    
    return [firstSectionIndex : (name: "Scripts for Reviews", settings: scriptsSettings) , othersSectionIndex : (name: "Other options", settings: otherSettings)]
  }()
  
  var userScriptsForReview: [UserScript] {
    var scripts = [UserScript]()
    for q in settings[0]!.settings {
      if let script = q.script where q.enabled == true {
        if script.name == SettingsSuit.smartResizingScript.name {
          var resizingScriptCopy = script
          resizingScriptCopy.modifyScript({ (script) -> (String) in
            
            let metrics = optimalReviewMetrics(self.hideStatusBarEnabled)
            
            var s = script.stringByReplacingOccurrencesOfString("HHH", withString: "\(metrics.height)")
            s = s.stringByReplacingOccurrencesOfString("WWW", withString: "\(metrics.width)")
            s = s.stringByReplacingOccurrencesOfString("FFF", withString: "\(metrics.scale)")
            
            return s
          })
          scripts.append(resizingScriptCopy)
          break
        }
        scripts.append(script)
      }
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
  
  var hideStatusBarEnabled: Bool {
    return settings[1]!.settings[0].enabled
  }
  
  // Keys
  static let fastForwardEnabledKey = "fastForwardEnabledKey"
  static let ignoreButtonEnabledKey = "ignoreButtonEnabledKey"
  static let smartResizingEnabledKey = "smartResizingEnabledKey"
  static let hideStatusBarKey = "hideStatusBarKey"
  
  // Scripts
  private(set) static var fastForwardScript = UserScript(filename: "fast_forward", scriptName: "Fast forward")
  private(set) static var ignoreButtonScript = UserScript(filename: "ignore", scriptName: "Ignore button")
  private(set) static var smartResizingScript = UserScript(filename: "resize", scriptName: "Smart resize")
  
}
