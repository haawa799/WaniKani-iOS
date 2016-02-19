//
//  KanjiSearch.swift
//  WaniKani
//
//  Created by Andriy K. on 1/18/16.
//  Copyright © 2016 Andriy K. All rights reserved.
//

import UIKit
import MobileCoreServices
import CoreSpotlight
import DataKit


extension Kanji {
  
  override public static func ignoredProperties() -> [String] {
    return ["domainIdentifier", "uniqueIdentifier", "userActivityUserInfo", "userActivity", "attributeSet"]
  }
  
  public var domainIdentifier: String {
    return Kanji.searchIdentifierForLevel(level)
  }
  
  public var uniqueIdentifier: String {
    return character
  }
  
  public static func searchIdentifierForLevel(level: Int) -> String {
    return "com.haawa.WaniKani.kanji.\(level)"
  }
  
  public var userActivityUserInfo: [NSObject: AnyObject] {
    return ["id": character]
  }
  
  public var userActivity: NSUserActivity {
    let activity = NSUserActivity(activityType: domainIdentifier)
    activity.userInfo = userActivityUserInfo
    if #available(iOS 9.0, *) {
      activity.contentAttributeSet = attributeSet
    } else {
      // Fallback on earlier versions
    }
    return activity
  }
  
}

@available(iOS 9.0, *)
extension Kanji {
  public var attributeSet: CSSearchableItemAttributeSet {
    let attributeSet = CSSearchableItemAttributeSet(
      itemContentType: kUTTypeItem as String)
    attributeSet.title = meaning
    
    var description = ""
    if let onyomi = onyomi {
      description += "onyomi: \(onyomi)"
    }
    if let kunyomi = kunyomi {
      description += ", kunyomi: \(kunyomi)"
    }
    attributeSet.contentDescription = description
    //
    let side: CGFloat = 180
    let canvas = CanvasView(frame: CGRect(x: 0, y: 0, width: side, height: side))
    canvas.char = character
    canvas.backgroundColor = UIColor.clearColor()
    canvas.setNeedsDisplay()
    let img = canvas.pb_takeSnapshot()
    attributeSet.thumbnailData = UIImagePNGRepresentation(img)
    //
    attributeSet.keywords = (meaning != nil) ? [character, meaning!] : [character]
    return attributeSet
  }
}

