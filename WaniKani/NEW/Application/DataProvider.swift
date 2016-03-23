//
//  DataProvider.swift
//  WaniKani
//
//  Created by Andriy K. on 3/22/16.
//  Copyright © 2016 Andriy K. All rights reserved.
//

import UIKit
import WaniKit
import RealmSwift
import Realm

typealias ProgressionBlock = (User?, LevelProgression?) -> ()

protocol DataProviderDelegate: class {
  func newProgressData(handler: ProgressionBlock)
}

struct DataProvider {
  
  weak var delegate: DataProviderDelegate?
  
  let waniApiManager: WaniApiManager = {
    let manager = WaniApiManager()
    manager.setApiKey("c6ce4072cf1bd37b407f2c86d69137e3")
    return manager
  }()
  
  func fetchProgression(handler: ProgressionBlock) {
    let oldUser = realm.objects(User).first
    let oldProgression = oldUser?.levelProgression
    handler(oldUser, oldProgression)
  }
  
}
