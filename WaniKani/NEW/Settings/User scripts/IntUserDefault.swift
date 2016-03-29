//
//  IntUserDefault.swift
//  WaniKani
//
//  Created by Andriy K. on 3/28/16.
//  Copyright © 2016 Andriy K. All rights reserved.
//

import Foundation

struct IntUserDefault {
  let key: String
  
  var delegate: SettingsDelegate?
  private var internalValue: AnyObject!
  
  var value: Int {
    didSet {
      if value != oldValue {
        NSUserDefaults.standardUserDefaults().setInteger(value, forKey: key)
        NSUserDefaults.standardUserDefaults().synchronize()
      }
    }
  }
  
  init(key: String) {
    self.key = key
    self.value = NSUserDefaults.standardUserDefaults().integerForKey(key)
  }
}