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
  
  let eventSuffix: String = {
    #if DEBUG
      return "debug_"
    #else
      return ""
    #endif
  }()
  
  enum FabricEventName: String {
    case BackgroundFetch = "Background fetch"
    case NotificationScheduled = "Notification scheduled"
    case KanjiStrokeOrderPractice = "Kanji stroke order practice"
  }
  
  enum FabricAttributesName: String {
    case Result = "Result"
    case IsBackgorundFetch = "isBackgroundFetch"
    case WebSessionType = "Web session type"
  }
  
  init() {
    Fabric.with([Crashlytics.self()])
    #if DEBUG
      Crashlytics.sharedInstance().debugMode = true
    #else
      Crashlytics.sharedInstance().debugMode = false
    #endif
  }
  
  func postUserSwipedToKanjiPractice(type: WebSessionType) {
    postEvent(.KanjiStrokeOrderPractice, attributes: ["\(eventSuffix)\(FabricAttributesName.WebSessionType.rawValue)" : "\(type)"])
  }
  
  func postBackgroundFetchEvent(result: UIBackgroundFetchResult) {
    postEvent(.BackgroundFetch, attributes: ["\(eventSuffix)\(FabricAttributesName.Result.rawValue)" : "\(result)"])
  }
  
  func postNotificationScheduled(backgroundCall: Bool) {
    postEvent(.NotificationScheduled, attributes: [ FabricAttributesName.IsBackgorundFetch.rawValue : "\(backgroundCall)" ])
  }
  
  func postEvent(eventName: FabricEventName, attributes: [String: AnyObject]?) {
    Answers.logCustomEventWithName("\(eventSuffix)\(eventName.rawValue)", customAttributes: attributes)
  }
  
  func crash() {
    Crashlytics.sharedInstance().crash()
  }
  
}
