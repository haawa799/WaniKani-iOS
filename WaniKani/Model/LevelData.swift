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
  
  func updateKanjiListForLevel(level: Int, newList: [KanjiInfo]) {
    
    guard levels.count > level else { return }
    
    let levelData = levels[level]
    
    let realmArray = List<Kanji>()
    for kanjiInfo in newList {
      realmArray.append(Kanji(kanjiInfo: kanjiInfo))
    }
    
    levelData.kanjiList = realmArray
  }
}

public class LevelData: Object {
  
  //public dynamic var radicalsList: [Radical]?
  public var kanjiList = List<Kanji>()
  //public dynamic var vocabList: [Word]?
  
}

public class Kanji: Object {
  
  public var character: String = ""
  public var meaning: String = ""
  public var onyomi: String = ""
  public var kunyomi: String = ""
  public var nanori: String = ""
  public var importantReading: String = ""
  public var level: Int = 0
  
  public dynamic var userSpecific: KanjiUserSpecific?
  
  public init(kanjiInfo: KanjiInfo) {
    super.init()
    
    character = kanjiInfo.character ?? ""
    meaning = kanjiInfo.meaning ?? ""
    onyomi = kanjiInfo.onyomi ?? ""
    kunyomi = kanjiInfo.kunyomi ?? ""
    nanori = kanjiInfo.nanori ?? ""
    importantReading = kanjiInfo.importantReading ?? ""
    level = kanjiInfo.level
    
    if let userSpecificQ = kanjiInfo.userSpecific {
      userSpecific = KanjiUserSpecific(info: userSpecificQ)
    }
  }
  
  public required init() {
    super.init()
  }
}

public class KanjiUserSpecific: Object {
  
  // Fields
  public dynamic var srs: String = ""
  public dynamic var srsNumeric: Int = 0
  public dynamic var unlocked: Bool = false
  public dynamic var unlockedDate: NSDate = NSDate()
  public dynamic var availableDate: NSDate = NSDate()
  public dynamic var burned: Bool = false
  public dynamic var burnedDate: NSDate = NSDate()
  public dynamic var meaningCorrect: Int = 0
  public dynamic var meaningIncorrect: Int = 0
  public dynamic var meaningMaxStreak: Int = 0
  public dynamic var meaningCurrentStreak: Int = 0
  public dynamic var readingCorrect: Int = 0
  public dynamic var readingIncorrect: Int = 0
  public dynamic var readingMaxStreak: Int = 0
  public dynamic var readingCurrentStreak: Int = 0
  public dynamic var meaningNote: String = ""
  public dynamic var userSynonyms: String = ""
  public dynamic var readingNote: String = ""
  
  public init(info: KanjiInfo.KanjiInfoUserSpecific) {
    super.init()
    
    srs = info.srs ?? ""
    srsNumeric = info.srsNumeric ?? 0
    unlocked = (info.unlockedDate != nil)
    unlockedDate = info.unlockedDate ?? NSDate()
    availableDate = info.availableDate ?? NSDate()
    burned = info.burned
    burnedDate = info.burnedDate ?? NSDate()
    meaningCorrect = info.meaningCorrect ?? 0
    meaningIncorrect = info.meaningIncorrect ?? 0
    meaningMaxStreak = info.meaningMaxStreak ?? 0
    meaningCurrentStreak = info.meaningCurrentStreak ?? 0
    readingCorrect = info.readingCorrect ?? 0
    readingIncorrect = info.readingIncorrect ?? 0
    readingMaxStreak = info.readingMaxStreak ?? 0
    readingCurrentStreak = info.readingCurrentStreak ?? 0
    meaningNote = info.meaningNote ?? ""
    userSynonyms = info.userSynonyms ?? ""
    readingNote = info.readingNote ?? ""
  }

  public required init() {
    super.init()
  }
}