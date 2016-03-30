//
//  SettingsSuit.swift
//  WaniKani
//
//  Created by Andriy K. on 10/7/15.
//  Copyright © 2015 Andriy K. All rights reserved.
//

import UIKit

private struct ScriptSetting {
  static let fastForwardScript = UserScript(filename: "fast_forward", scriptName: "Fast forward")
  static let ignoreButtonScript = UserScript(filename: "ignore", scriptName: "Ignore button")
  static let smartResizingScript = UserScript(filename: "resize", scriptName: "Smart resize")
  static let reorderScript = UserScript(filename: "reorder", scriptName: "Reorder script")
  static let scoreScript = UserScript(filename: "score", scriptName: "Score script")
}

private struct SettingsSuitSettings {
  static let fastForwardSetting: Setting = Setting(key: SettingSuitKey.fastForwardEnabledKey, script: ScriptSetting.fastForwardScript, description: ScriptSetting.fastForwardScript.name)
  static let ignoreButtonSetting: Setting = Setting(key: SettingSuitKey.ignoreButtonEnabledKey, script: ScriptSetting.ignoreButtonScript, description: ScriptSetting.ignoreButtonScript.name)
  static let reorderSetting: Setting = Setting(key: SettingSuitKey.reorderEnabledKey, script: ScriptSetting.reorderScript, description: ScriptSetting.reorderScript.name)
  static let smartResizingSetting: Setting = Setting(key: SettingSuitKey.smartResizingEnabledKey, script: ScriptSetting.smartResizingScript, description: ScriptSetting.smartResizingScript.name)
  // === Second section ===================
  static let hideStatusBarSetting: Setting = Setting(key: SettingSuitKey.hideStatusBarKey, script: nil, description: "Status bar hidden on Reviews")
  static let shouldUseGCSetting: Setting = Setting(key: SettingSuitKey.shouldUseGameCenterKey, script: nil, description: "Use GameCenter")
  static let gameCenterDummySetting: Setting = Setting(key: SettingSuitKey.gameCenterKey, script: nil, description: "Game center")
  static let ignoreLessonsInIconCounter: Setting = Setting(key: SettingSuitKey.ignoreLessonsInIconBadgeKey, script: nil, description: "Ignore lessons in icon badge")
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
  
  private var allSettings: [Setting] {
    return [
      SettingsSuitSettings.fastForwardSetting,
      SettingsSuitSettings.ignoreButtonSetting,
      SettingsSuitSettings.reorderSetting,
      SettingsSuitSettings.smartResizingSetting,
      SettingsSuitSettings.hideStatusBarSetting,
      SettingsSuitSettings.shouldUseGCSetting,
      SettingsSuitSettings.ignoreLessonsInIconCounter
    ]
  }
  
  private func settingWithID(id: String) -> Setting? {
    let setting = allSettings.filter ({ $0.key.rawValue == id }).first
    return setting
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
  
  func changeSetting(id: String, state: Bool) {
    guard var setting = settingWithID(id) else { return }
    setting.enabled = state
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