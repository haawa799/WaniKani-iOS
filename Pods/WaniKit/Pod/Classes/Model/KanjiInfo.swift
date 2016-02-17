//
//  KanjiInfo.swift
//  Pods
//
//  Created by Andriy K. on 12/27/15.
//
//

import Foundation

public struct UserSpecific: DictionaryInitialization {
  
  // Dictionary keys
  private static let keySrs = "srs"
  private static let keySrsNumeric = "srs_numeric"
  private static let keyUnlockDate = "unlocked_date"
  private static let keyAvaliableDate = "available_date"
  private static let keyBurned = "burned"
  private static let keyBurnedDate = "burned_date"
  private static let keyMeaningCorrect = "meaning_correct"
  private static let keyMeaningIncorrect = "meaning_incorrect"
  private static let keyMeaningMaxStreak = "meaning_max_streak"
  private static let keyMeaningCurrentStreak = "meaning_current_streak"
  private static let keyReadingCorrect = "reading_correct"
  private static let keyReadingIncorrect = "reading_incorrect"
  private static let keyReadingMaxStreak = "reading_max_streak"
  private static let keyReadingCurrentStreak = "reading_current_streak"
  private static let keyMeaningNote = "meaning_note"
  private static let keyUserSynonyms = "user_synonyms"
  private static let keyReadingNote = "reading_note"
  
  
  // Fields
  public var srs: String?
  public var srsNumeric: Int?
  public var unlockedDate: NSDate?
  public var availableDate: NSDate?
  public var burned: Bool
  public var burnedDate: NSDate?
  public var meaningCorrect: Int?
  public var meaningIncorrect: Int?
  public var meaningMaxStreak: Int?
  public var meaningCurrentStreak: Int?
  public var readingCorrect: Int?
  public var readingIncorrect: Int?
  public var readingMaxStreak: Int?
  public var readingCurrentStreak: Int?
  public var meaningNote: String?
  public var userSynonyms: String?
  public var readingNote: String?
  
  
  public init(dict: NSDictionary) {
    
    srs = (dict[UserSpecific.keySrs] as? String)
    srsNumeric = (dict[UserSpecific.keySrsNumeric] as? Int)
    burned = (dict[UserSpecific.keyBurned] as! Bool)
    
    if let unlock = dict[UserSpecific.keyUnlockDate] as? Int {
      unlockedDate = NSDate(timeIntervalSince1970: NSTimeInterval(unlock))
    }
    if let avaliable = dict[UserSpecific.keyAvaliableDate] as? Int {
      availableDate = NSDate(timeIntervalSince1970: NSTimeInterval(avaliable))
    }
    if let burnedDateInt = dict[UserSpecific.keyAvaliableDate] as? Int {
      burnedDate = NSDate(timeIntervalSince1970: NSTimeInterval(burnedDateInt))
    }
    
    meaningCorrect = (dict[UserSpecific.keyMeaningCorrect] as? Int)
    meaningIncorrect = (dict[UserSpecific.keyMeaningIncorrect] as? Int)
    meaningMaxStreak = (dict[UserSpecific.keyMeaningMaxStreak] as? Int)
    meaningCurrentStreak = (dict[UserSpecific.keyMeaningCurrentStreak] as? Int)
    readingCorrect = (dict[UserSpecific.keyReadingCorrect] as? Int)
    readingIncorrect = (dict[UserSpecific.keyReadingIncorrect] as? Int)
    readingMaxStreak = (dict[UserSpecific.keyReadingMaxStreak] as? Int)
    readingCurrentStreak = (dict[UserSpecific.keyReadingCurrentStreak] as? Int)
    meaningNote = (dict[UserSpecific.keyMeaningNote] as? String)
    userSynonyms = (dict[UserSpecific.keyUserSynonyms] as? String)
    readingNote = (dict[UserSpecific.keyReadingNote] as? String)
  }
  
}

public struct KanjiInfo {
  
  // Dictionary keys
  private static let keyCharacter = "character"
  private static let keyMeaning = "meaning"
  private static let keyOnyomi = "onyomi"
  private static let keyKunyomi = "kunyomi"
  private static let keyNanori = "nanori"
  private static let keyImportantReading = "important_reading"
  private static let keyLevel = "level"
  
  private static let keyUserSpecific = "user_specific"
  
  public var character: String
  public var meaning: String?
  public var onyomi: String?
  public var kunyomi: String?
  public var nanori: String?
  public var importantReading: String?
  public var level: Int
  
  public var userSpecific: UserSpecific?
}

extension KanjiInfo: DictionaryInitialization {
  
  public init(dict: NSDictionary) {
    character = dict[KanjiInfo.keyCharacter] as! String
    meaning = dict[KanjiInfo.keyMeaning] as? String
    onyomi = dict[KanjiInfo.keyOnyomi] as? String
    kunyomi = dict[KanjiInfo.keyKunyomi] as? String
    nanori = dict[KanjiInfo.keyNanori] as? String
    importantReading = dict[KanjiInfo.keyImportantReading] as? String
    level = dict[KanjiInfo.keyLevel] as! Int
    
    if let userSpecificDict = dict[KanjiInfo.keyUserSpecific] as? NSDictionary {
      userSpecific = UserSpecific(dict: userSpecificDict)
    }
  }
}