//
//  KeychainManager.swift
//  WaniKani
//
//  Created by Andriy K. on 2/2/16.
//  Copyright © 2016 Andriy K. All rights reserved.
//

import UIKit
import UICKeyChainStore

struct KeychainManager {
  
  let apiKeyStoreKey = "WaniKaniApiKey"
  let keychain = UICKeyChainStore(service: "com.haawa.WaniKani")
  let firstRunDefaultsKey = "FirstRun"
  let firstRunValue = "1strun"
  
  func cleanKeychainIfNeeded() {
    
    if (NSUserDefaults.standardUserDefaults().objectForKey(firstRunDefaultsKey) == nil) {
      keychain[apiKeyStoreKey] = nil
      NSUserDefaults.standardUserDefaults().setValue(firstRunValue, forKey: firstRunDefaultsKey)
      NSUserDefaults.standardUserDefaults().synchronize()
    }
  }
  
  var apiKey: String? {
    return keychain[apiKeyStoreKey]
  }
  
  func setNewApiKey(key: String) {
    keychain[apiKeyStoreKey] = key
  }
}
