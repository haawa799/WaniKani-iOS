//
//  SettingsSuit.swift
//  WaniKani
//
//  Created by Andriy K. on 10/7/15.
//  Copyright © 2015 Andriy K. All rights reserved.
//

import UIKit

private struct SettingSuitKeys {
  static let fastForwardEnabledKey = "fastForwardEnabledKey"
  static let ignoreButtonEnabledKey = "ignoreButtonEnabledKey"
  static let smartResizingEnabledKey = "smartResizingEnabledKey"
  static let reorderEnabledKey = "reorderEnabledKey"
  static let hideStatusBarKey = "hideStatusBarKey"
  static let gameCenterKey = "gameCenterKey"
  static let shouldUseGameCenterKey = "shouldUSeGameCenter"
  static let ignoreLessonsInIconBadgeKey = "ignoreLessonsInIconBadgeKey"
}

private struct ScriptSetting {
  static let fastForwardScript = UserScript(filename: "fast_forward", scriptName: "Fast forward")
  static let ignoreButtonScript = UserScript(filename: "ignore", scriptName: "Ignore button")
  static let smartResizingScript = UserScript(filename: "resize", scriptName: "Smart resize")
  static let reorderScript = UserScript(filename: "reorder", scriptName: "Reorder script")
  static let scoreScript = UserScript(filename: "score", scriptName: "Score script")
}

private struct SettingsSuitSettings {
  static let fastForwardSetting: Setting = Setting(key: SettingSuitKeys.fastForwardEnabledKey, script: ScriptSetting.fastForwardScript, description: ScriptSetting.fastForwardScript.name)
  static let ignoreButtonSetting: Setting = Setting(key: SettingSuitKeys.ignoreButtonEnabledKey, script: ScriptSetting.ignoreButtonScript, description: ScriptSetting.ignoreButtonScript.name)
  static let reorderSetting: Setting = Setting(key: SettingSuitKeys.reorderEnabledKey, script: ScriptSetting.reorderScript, description: ScriptSetting.reorderScript.name)
  static let smartResizingSetting: Setting = Setting(key: SettingSuitKeys.smartResizingEnabledKey, script: ScriptSetting.smartResizingScript, description: ScriptSetting.smartResizingScript.name)
  // === Second section ===================
  static let hideStatusBarSetting: Setting = Setting(key: SettingSuitKeys.hideStatusBarKey, script: nil, description: "Status bar hidden on Reviews")
  static let shouldUseGCSetting: Setting = Setting(key: SettingSuitKeys.shouldUseGameCenterKey, script: nil, description: "Use GameCenter")
  static let gameCenterDummySetting: Setting = Setting(key: SettingSuitKeys.gameCenterKey, script: nil, description: "Game center")
  static let ignoreLessonsInIconCounter: Setting = Setting(key: SettingSuitKeys.ignoreLessonsInIconBadgeKey, script: nil, description: "Ignore lessons in icon badge")
}

struct SettingsSuit {
  
  private let userDefaults: NSUserDefaults
  private let keychainManager: KeychainManager
  
  init(userDefaults: NSUserDefaults, keychainManager: KeychainManager) {
    self.userDefaults = userDefaults
    self.keychainManager = keychainManager
  }
  
  private var userScriptsForReview: [UserScript] {
    return [
      ScriptSetting.fastForwardScript,
      ScriptSetting.ignoreButtonScript,
      ScriptSetting.smartResizingScript,
      ScriptSetting.reorderScript,
      ScriptSetting.scoreScript
    ]
  }
}

// Public API
extension SettingsSuit {
  
  var collectionViewViewModel: CollectionViewViewModel {
    let headerColor = ColorConstants.settingsTintColor
    let sections = [
      // Section 0
      CollectionViewSection(CollectionViewCellDataItem((DashboardHeaderViewModel(title: "Scripts for Reviews", color: headerColor) as ViewModel), DashboardHeader.identifier), [
        CollectionViewCellDataItem((SettingsScriptCellViewModel(setting: SettingsSuitSettings.fastForwardSetting) as ViewModel), SettingsScriptCell.identifier),
        CollectionViewCellDataItem((SettingsScriptCellViewModel(setting: SettingsSuitSettings.ignoreButtonSetting) as ViewModel), SettingsScriptCell.identifier),
        CollectionViewCellDataItem((SettingsScriptCellViewModel(setting: SettingsSuitSettings.reorderSetting) as ViewModel), SettingsScriptCell.identifier),
        CollectionViewCellDataItem((SettingsScriptCellViewModel(setting: SettingsSuitSettings.smartResizingSetting) as ViewModel), SettingsScriptCell.identifier)
        ]),
      // Section 2
      CollectionViewSection(CollectionViewCellDataItem((DashboardHeaderViewModel(title: "Other options", color: headerColor) as ViewModel), DashboardHeader.identifier), [
        CollectionViewCellDataItem((SettingsScriptCellViewModel(setting: SettingsSuitSettings.hideStatusBarSetting) as ViewModel), SettingsScriptCell.identifier),
        CollectionViewCellDataItem((SettingsScriptCellViewModel(setting: SettingsSuitSettings.shouldUseGCSetting) as ViewModel), SettingsScriptCell.identifier),
        CollectionViewCellDataItem((GameCenterCellViewModel(setting: SettingsSuitSettings.gameCenterDummySetting) as ViewModel), GameCenterCollectionViewCell.identifier)
        ]),
      // Section 3
      CollectionViewSection(CollectionViewCellDataItem((DashboardHeaderViewModel(title: "Notifications options", color: headerColor) as ViewModel), DashboardHeader.identifier), [
        CollectionViewCellDataItem((SettingsScriptCellViewModel(setting: SettingsSuitSettings.ignoreLessonsInIconCounter) as ViewModel), SettingsScriptCell.identifier)
        ])
    ]
    return CollectionViewViewModel(sections: sections)
  }
  
  var hideStatusBarEnabled: Bool {
    return SettingsSuitSettings.hideStatusBarSetting.enabled
  }
  
  var shouldUseGameCenter: Bool {
    return SettingsSuitSettings.shouldUseGCSetting.enabled
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
    
    if let user = self.keychainManager.user, let password = keychainManager.password {
      webView.stringByEvaluatingJavaScriptFromString("loginIfNeeded('\(user)','\(password)');");
    }
  }
  
}