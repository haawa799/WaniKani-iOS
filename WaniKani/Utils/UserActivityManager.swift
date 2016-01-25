//
//  UserActivityManager.swift
//  WaniKani
//
//  Created by Andriy K. on 1/22/16.
//  Copyright © 2016 Andriy K. All rights reserved.
//

import UIKit
import CoreSpotlight

class UserActivityManager: NSObject {
  
  private var lastInexedLevelSetting = IntUserDefault(key: "lastInexedLevelDefaultsKey")
  
  override init() {
    super.init()
    appDelegate.notificationCenterManager.addObserver(self, notification: .UpdatedKanjiListNotification, selector: "newKanjiData:")
  }
  
  deinit {
    appDelegate.notificationCenterManager.removeObserver(self)
  }
  
  func newKanjiData(notification: NSNotification) {
    
    guard #available(iOS 9.0, *) else { return }
    
    guard let level = notification.object as? Int, let currentLvl = user?.level where level <= currentLvl else { return }
    
    let lastIndexedLevel = lastInexedLevelSetting.value // 11
    
    let numberOfLevelsToIndex = 5
    
    guard (lastIndexedLevel != 0) && (lastIndexedLevel != currentLvl) else { return }
    let oldMinIndexedLevel = max(lastIndexedLevel - numberOfLevelsToIndex + 1, 1)
    let minLevelToIndex = max(currentLvl - numberOfLevelsToIndex + 1, 1)
    
    let levelsToRemoveFromIndex = [Int](oldMinIndexedLevel..<min(minLevelToIndex, oldMinIndexedLevel + lastIndexedLevel))
    let domainIdentifiersToRemove = levelsToRemoveFromIndex.map { (index) -> String in
      return Kanji.searchIdentifierForLevel(index)
    }
    
    CSSearchableIndex.defaultSearchableIndex().deleteSearchableItemsWithIdentifiers(domainIdentifiersToRemove, completionHandler: { (error) -> Void in
        print(error)
      })
  
    let levelsToIndex = [Int](max(lastIndexedLevel + 1, currentLvl - numberOfLevelsToIndex + 1)...currentLvl)
    
    if levelsToIndex.contains(level) {
      
      if let levelKanji = user?.levels?.levels[level].kanjiList {
        let kanjiSearchableItems = levelKanji.map({ (kanji) -> CSSearchableItem in
          let item = CSSearchableItem(uniqueIdentifier: kanji.uniqueIdentifier, domainIdentifier: kanji.domainIdentifier, attributeSet: kanji.attributeSet)
          return item
        })
        CSSearchableIndex.defaultSearchableIndex().indexSearchableItems(kanjiSearchableItems, completionHandler: { (error) -> Void in
          print(error)
        })
      }
      
    }
    
    // Add items
    
    print(currentLvl)
    print(level)
    
    
  }
}
