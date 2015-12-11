//
//  FabricEventsManager.swift
//  WaniKani
//
//  Created by Andriy K. on 12/11/15.
//  Copyright © 2015 Andriy K. All rights reserved.
//

import UIKit
import Crashlytics
import Fabric


struct FabricEventsManager {
  
  enum FabricEventName: String {
    case BackgroundFetch = "Background fetch"
  }
  
  enum FabricAttributesName: String {
    case Result = "Result"
  }
  
  init() {
    Fabric.with([Crashlytics.self()])
    Crashlytics.sharedInstance().debugMode = true
  }
  
  func postBackgroundFetchEvent(result: UIBackgroundFetchResult) {
    postEvent(.BackgroundFetch, attributes: [FabricAttributesName.Result.rawValue : "\(result)"])
  }
  
  func postEvent(eventName: FabricEventName, attributes: [String: AnyObject]?) {
    Answers.logCustomEventWithName(eventName.rawValue, customAttributes: attributes)
  }
  
}
