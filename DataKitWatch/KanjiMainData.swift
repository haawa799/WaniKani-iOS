//
//  KanjiMainData.swift
//  WaniKani
//
//  Created by Andriy K. on 2/20/16.
//  Copyright © 2016 Andriy K. All rights reserved.
//

import Foundation

public class KanjiMainData: NSObject, NSCoding {
  
  public var character: String = ""
  public var meaning: String = ""
  public var on: String = ""
  public var kun: String = ""
  public var unlocked: Bool = false
  public var burned: Bool = false
  public var level: Int = 0
  
  override init() {
    super.init()
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
    
    aCoder.encodeBool(self.unlocked, forKey: keyUnlocked)
    aCoder.encodeBool(self.burned, forKey: keyBurned)
    aCoder.encodeInteger(self.level, forKey: keyLevel)
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