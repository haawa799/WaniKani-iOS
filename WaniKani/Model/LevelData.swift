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
  
  public var levels: List<LevelData> = {
    let list = List<LevelData>()
    for i in 0..<100 {
      list.append(LevelData())
    }
    return list
  }()
  
  func updateKanjiListForLevel(level: Int, newList: [KanjiInfo]) {
    
    guard levels.count > level && newList.count > 0 else { return }
    
    let kanjiListEmpty = levels[level].kanjiList.count == 0
    
    for kanjiInfo in newList {
      let k = Kanji(kanjiInfo: kanjiInfo)
      realm?.add(k, update: true)
      
      if kanjiListEmpty {
        levels[level].kanjiList.append(k)
      }
    }
    realm?.refresh()
  }
}

public class LevelData: Object {
  
  //public dynamic var radicalsList: [Radical]?
  public var kanjiList = List<Kanji>()
  //public dynamic var vocabList: [Word]?
  
}

public class Kanji: Object {
  
  public dynamic var character: String = ""
  public dynamic var meaning: String?
  public dynamic var onyomi: String?
  public dynamic var kunyomi: String?
  public dynamic var nanori: String?
  public dynamic var importantReading: String?
  public dynamic var level: Int = 0
  
  public dynamic var userSpecific: KanjiUserSpecific?
  
  override public static func primaryKey() -> String? {
    return "character"
  }
  
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
      userSpecific = KanjiUserSpecific(info: userSpecificQ)
    }
  }
}

public class KanjiUserSpecific: Object {
  
  // Fields
  public dynamic var srs: String?
  public var srsNumeric = RealmOptional<Int>()
  public dynamic var unlockedDate: NSDate?
  public dynamic var availableDate: NSDate?
  public dynamic var burned: Bool = false
  public dynamic var burnedDate: NSDate?
  public var meaningCorrect = RealmOptional<Int>()
  public var meaningIncorrect = RealmOptional<Int>()
  public var meaningMaxStreak = RealmOptional<Int>()
  public var meaningCurrentStreak = RealmOptional<Int>()
  public var readingCorrect = RealmOptional<Int>()
  public var readingIncorrect = RealmOptional<Int>()
  public var readingMaxStreak = RealmOptional<Int>()
  public var readingCurrentStreak = RealmOptional<Int>()
  public dynamic var meaningNote: String?
  public dynamic var userSynonyms: String?
  public dynamic var readingNote: String?
  
  public convenience init(info: KanjiInfo.KanjiInfoUserSpecific) {
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