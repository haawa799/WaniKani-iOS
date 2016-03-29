//
//  Setting.swift
//  WaniKani
//
//  Created by Andriy K. on 3/28/16.
//  Copyright © 2016 Andriy K. All rights reserved.
//

import Foundation

protocol SettingsDelegate {
  func settingDidChange(setting: Setting)
}

struct Setting: Equatable {
  let key: String
  let script: UserScript?
  let description: String?
  
  var delegate: SettingsDelegate?
  
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

func ==(lhs: Setting, rhs: Setting) -> Bool {
  return lhs.key == rhs.key
}