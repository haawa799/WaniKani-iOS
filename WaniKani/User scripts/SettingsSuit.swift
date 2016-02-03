//
//  SettingsSuit.swift
//  WaniKani
//
//  Created by Andriy K. on 10/7/15.
//  Copyright © 2015 Andriy K. All rights reserved.
//

import UIKit

protocol SettingsDelegate: class {
  func settingDidChange(setting: Setting)
}

class Setting {
  let key: String
  let script: UserScript?
  let description: String?
  
  weak var delegate: SettingsDelegate?
  
  var enabled: Bool = false {
    didSet {
      if enabled != oldValue {
        NSUserDefaults.standardUserDefaults().setBool(enabled, forKey: key)
        NSUserDefaults.standardUserDefaults().synchronize()
        delegate?.settingDidChange(self)
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

class IntUserDefault {
  let key: String
  
  weak var delegate: SettingsDelegate?
  private var internalValue: AnyObject!
  
  var value: Int {
    didSet {
      if value != oldValue {
        NSUserDefaults.standardUserDefaults().setInteger(value, forKey: key)
        NSUserDefaults.standardUserDefaults().synchronize()
      }
    }
  }
  
  required init(key: String) {
    self.key = key
    self.value = NSUserDefaults.standardUserDefaults().integerForKey(key)
  }
}

extension Setting: Equatable { }
func ==(lhs: Setting, rhs: Setting) -> Bool {
  return lhs.key == rhs.key
}

class SettingsSuit: NSObject {
  
  typealias SettingOption = (setting: Setting, indexPath: NSIndexPath)
  static let sharedInstance = SettingsSuit()
  
  // === First section ===================
  let fastForwardSetting:SettingOption = (Setting(key: fastForwardEnabledKey, script: fastForwardScript, description: fastForwardScript.name), NSIndexPath(forItem: 0, inSection: 0))
  let ignoreButtonSetting:SettingOption = (Setting(key: ignoreButtonEnabledKey, script: ignoreButtonScript, description: ignoreButtonScript.name), NSIndexPath(forItem: 1, inSection: 0))
  let reorderSetting:SettingOption = (Setting(key: reorderEnabledKey, script: reorderScript, description: reorderScript.name), NSIndexPath(forItem: 2, inSection: 0))
  let smartResizingSetting:SettingOption = (Setting(key: smartResizingEnabledKey, script: smartResizingScript, description: smartResizingScript.name), NSIndexPath(forItem: 3, inSection: 0))
  // === Second section ===================
  let hideStatusBarSetting:SettingOption = (Setting(key: hideStatusBarKey, script: nil, description: "Status bar hidden on Reviews"), NSIndexPath(forItem: 0, inSection: 1))
  let shouldUseGCSetting:SettingOption = (Setting(key: shouldUseGameCenterKey, script: nil, description: "Use GameCenter"), NSIndexPath(forItem: 1, inSection: 1))
  let gameCenterDummySetting:SettingOption = (Setting(key: gameCenterKey, script: nil, description: "Game center"), NSIndexPath(forItem: 2, inSection: 1))
  // ======================================
  let ignoreLessonsInIconCounter:SettingOption = (Setting(key: ignoreLessonsInIconBadgeKey, script: nil, description: "Ignore lessons in icon badge"), NSIndexPath(forItem: 3, inSection: 1))
  // ======================================
  
  lazy private(set) var settings: [Int: (name: String, settings:[Setting])] = {
    
    // Scripts
    let firstSectionIndex = 0
    var scriptsSettings = [Setting]()
    scriptsSettings.append(self.fastForwardSetting.setting)
    scriptsSettings.append(self.ignoreButtonSetting.setting)
    scriptsSettings.append(self.reorderSetting.setting)
    if PhoneModel.myModel() != .iPhone4 {
      scriptsSettings.append(self.smartResizingSetting.setting)
    }
    
    // Other options
    let othersSectionIndex = 1
    var otherSettings = [Setting]()
    otherSettings.append(self.hideStatusBarSetting.setting)
    self.shouldUseGCSetting.setting.delegate = self
    otherSettings.append(self.shouldUseGCSetting.setting)
    otherSettings.append(self.gameCenterDummySetting.setting)
    
    // Notifications options
    let notificationsSectionIndex = 2
    var notificationsSettings = [Setting]()
    notificationsSettings.append(self.ignoreLessonsInIconCounter.setting)
    
    return [firstSectionIndex : (name: "Scripts for Reviews", settings: scriptsSettings) , othersSectionIndex : (name: "Other options", settings: otherSettings) , notificationsSectionIndex: (name: "Notifications options", settings: notificationsSettings)]
  }()
  
  var userScriptsForReview: [UserScript] {
    var scripts = [SettingsSuit.scoreScript]
    let firstSection = settings[0]!.settings
    
    print(firstSection)
    
    for q in firstSection {
      
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
    
    /////
    if let user = appDelegate.keychainManager.user, let password = appDelegate.keychainManager.password {
      webView.stringByEvaluatingJavaScriptFromString("loginIfNeeded('\(user)','\(password)');");
    }
  }
  
  var hideStatusBarEnabled: Bool {
    return hideStatusBarSetting.setting.enabled
  }
  
  var shouldUseGameCenter: Bool {
    return shouldUseGCSetting.setting.enabled
  }
  
  // Keys
  static let fastForwardEnabledKey = "fastForwardEnabledKey"
  static let ignoreButtonEnabledKey = "ignoreButtonEnabledKey"
  static let smartResizingEnabledKey = "smartResizingEnabledKey"
  static let reorderEnabledKey = "reorderEnabledKey"
  
  static let hideStatusBarKey = "hideStatusBarKey"
  static let gameCenterKey = "gameCenterKey"
  static let shouldUseGameCenterKey = "shouldUSeGameCenter"
  static let ignoreLessonsInIconBadgeKey = "ignoreLessonsInIconBadgeKey"
  
  // Scripts
  private(set) static var fastForwardScript = UserScript(filename: "fast_forward", scriptName: "Fast forward")
  private(set) static var ignoreButtonScript = UserScript(filename: "ignore", scriptName: "Ignore button")
  private(set) static var smartResizingScript = UserScript(filename: "resize", scriptName: "Smart resize")
  private(set) static var reorderScript = UserScript(filename: "reorder", scriptName: "Reorder script")
  private(set) static var scoreScript = UserScript(filename: "score", scriptName: "Score script")
  
}

extension SettingsSuit: SettingsDelegate {
  func settingDidChange(setting: Setting) {
    
    if setting == ignoreButtonSetting.setting {
      DataFetchManager.sharedInstance.fetchAllData()
    } else if setting == shouldUseGCSetting.setting && setting.enabled == true {
      AwardsManager.sharedInstance.authenticateLocalPlayer()
    }
  }
}
