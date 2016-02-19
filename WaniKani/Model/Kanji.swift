//
//  Kanji.swift
//  WaniKani
//
//  Created by Andriy K. on 2/18/16.
//  Copyright © 2016 Andriy K. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

public class Kanji: Object {
  
  public dynamic var character: String = ""
  public dynamic var meaning: String?
  public dynamic var onyomi: String?
  public dynamic var kunyomi: String?
  public dynamic var nanori: String?
  public dynamic var importantReading: String?
  public dynamic var level: Int = 0
  
  public dynamic var userSpecific: ItemUserSpecific?
  
  override public static func primaryKey() -> String? {
    return "character"
  }
}


// Main data
public extension Kanji {
  
  public class KanjiMainData: NSObject, NSCoding {
    
    let character: String
    let meaning: String
    let on: String
    let kun: String
    let unlocked: Bool
    let burned: Bool
    let level: Int
    
    init(kanji: Kanji) {
      character = kanji.character
      meaning = kanji.meaning ?? ""
      on = kanji.onyomi ?? ""
      kun = kanji.kunyomi ?? ""
      unlocked = (kanji.userSpecific?.unlockedDate != nil)
      burned = kanji.userSpecific?.burned ?? false
      level = kanji.level
    }
    
    // Coding
    let keyCharacter = "character"
    let keyMeaning = "meaning"
    let keyOn = "on"
    let keyKun = "kun"
    let keyUnlocked = "unlocked"
    let keyBurned = "burned"
    let keyLevel = "level"
    
    
    public func encodeWithCoder(aCoder: NSCoder) {
      aCoder.encodeObject(self.character, forKey: keyCharacter)
      aCoder.encodeObject(self.meaning, forKey: keyMeaning)
      aCoder.encodeObject(self.on, forKey: keyOn)
      aCoder.encodeObject(self.kun, forKey: keyKun)
      
      aCoder.encodeObject(self.unlocked, forKey: keyUnlocked)
      aCoder.encodeObject(self.burned, forKey: keyBurned)
      aCoder.encodeObject(self.level, forKey: keyLevel)
    }
    
    required public init(coder aDecoder: NSCoder) {
      self.character = aDecoder.decodeObjectForKey(keyCharacter) as! String
      self.meaning = aDecoder.decodeObjectForKey(keyMeaning) as! String
      self.on = aDecoder.decodeObjectForKey(keyOn) as! String
      self.kun = aDecoder.decodeObjectForKey(keyKun) as! String
      self.unlocked = aDecoder.decodeBoolForKey(keyUnlocked)
      self.burned = aDecoder.decodeBoolForKey(keyBurned)
      self.level = aDecoder.decodeIntegerForKey(keyLevel)
    }
  }
  
  var mainData: KanjiMainData {
    return KanjiMainData(kanji: self)
  }
}