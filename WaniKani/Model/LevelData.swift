//
//  LevelData.swift
//  WaniKani
//
//  Created by Andriy K. on 1/14/16.
//  Copyright © 2016 Andriy K. All rights reserved.
//

import UIKit
import WaniKit
import RealmSwift
import Realm


public class WaniKaniLevels: Object {
  
  public var levels = List<LevelData>()
  
  func levelDataForLevel(level: Int) -> LevelData? {
    return (levels.filter{ $0.level == level }).first
  }
  
  func updateKanjiListForLevel(level: Int, newList: [KanjiInfo]) {
    
    guard newList.count > 0 else {
      return
    }
    
    var curLevelData: LevelData
    
    if let currentLevelData = levelDataForLevel(level) {
      curLevelData = currentLevelData
      print(currentLevelData)
    } else {
      // LevelData object not created yet
      let newLeveData = LevelData()
      realm?.add(newLeveData)
      levels.append(newLeveData)
      
      curLevelData = newLeveData
    }
    
    curLevelData.level = level
    let kanjiListEmpty = curLevelData.kanjiList.count == 0
    
    for kanjiInfo in newList {
      let k = Kanji(kanjiInfo: kanjiInfo)
      realm?.add(k, update: true)
      
      if kanjiListEmpty {
        curLevelData.kanjiList.append(k)
      }
    }
    realm?.refresh()
  }
}

public class LevelData: Object {
  
  public dynamic var level: Int = 0
  
  //public dynamic var radicalsList: [Radical]?
  public var kanjiList = List<Kanji>()
  //public dynamic var vocabList: [Word]?
  
}

public extension Kanji {
  
  public convenience init(kanjiInfo: KanjiInfo) {
    self.init()
    
    character = kanjiInfo.character
    meaning = kanjiInfo.meaning
    onyomi = kanjiInfo.onyomi
    kunyomi = kanjiInfo.kunyomi
    nanori = kanjiInfo.nanori
    importantReading = kanjiInfo.importantReading
    level = kanjiInfo.level
    
    if let userSpecificQ = kanjiInfo.userSpecific {
      userSpecific = ItemUserSpecific(info: userSpecificQ)
    }
  }
}

public class Radical: Object {
  
  public dynamic var character: String?
  public dynamic var meaning: String?
  public dynamic var image: String?
  public var level: Int = 0
  
  public dynamic var userSpecific: ItemUserSpecific?
  
  public convenience init(radicalInfo: RadicalInfo) {
    self.init()
    
    character = radicalInfo.character
    meaning = radicalInfo.meaning
    image = radicalInfo.image
    level = radicalInfo.level
    
    if let userSpecificQ = radicalInfo.userSpecific {
      userSpecific = ItemUserSpecific(info: userSpecificQ)
    }
  }
  
}

public class Word: Object {
  
  public dynamic var character: String = ""
  public dynamic var meaning: String?
  public dynamic var kana: String?
  public var level: Int = 0
  
  public dynamic var userSpecific: ItemUserSpecific?
  
  public convenience init(wordInfo: WordInfo) {
    self.init()
    
    character = wordInfo.character
    meaning = wordInfo.meaning
    kana = wordInfo.kana
    level = wordInfo.level
    
    if let userSpecificQ = wordInfo.userSpecific {
      userSpecific = ItemUserSpecific(info: userSpecificQ)
    }
  }
  
}

public extension ItemUserSpecific {
  
  public convenience init(info: UserSpecific) {
    self.init()
    
    srs = info.srs
    srsNumeric = RealmOptional(info.srsNumeric)
    unlockedDate = info.unlockedDate
    availableDate = info.availableDate
    burned = info.burned
    burnedDate = info.burnedDate
    meaningCorrect = RealmOptional(info.meaningCorrect)
    meaningIncorrect = RealmOptional(info.meaningIncorrect)
    meaningMaxStreak = RealmOptional(info.meaningMaxStreak)
    meaningCurrentStreak = RealmOptional(info.meaningCurrentStreak)
    readingCorrect = RealmOptional(info.readingCorrect)
    readingIncorrect = RealmOptional(info.readingIncorrect)
    readingMaxStreak = RealmOptional(info.readingMaxStreak)
    readingCurrentStreak = RealmOptional(info.readingCurrentStreak)
    meaningNote = info.meaningNote
    userSynonyms = info.userSynonyms
    readingNote = info.readingNote
  }
  
}
