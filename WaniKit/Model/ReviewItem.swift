//
//  ReviewItem.swift
//  WaniKani
//
//  Created by Andriy K. on 11/3/15.
//  Copyright © 2015 Andriy K. All rights reserved.
//

import RealmSwift

public enum ReviewItemType {
  case Radical
  case Kanji
  case Vocabulary
  
  public var toString: String {
    return "\(self)".lowercaseString
  }
  
  public init(string: String) {
    if string == ReviewItemType.Radical.toString {self = .Radical}
    else if string == ReviewItemType.Kanji.toString {self = .Kanji}
    else {self = .Vocabulary}
  }
}

public protocol ItemColor {
  func backgroundColor() -> UIColor?
}


//====================================================================
// MARK - ReviewItem
//====================================================================
public class ReviewItem: Object, DictionaryInitialization {
  
  // Dictionary keys
  private static let keyCharacter = "character"
  private static let keyMeaning = "meaning"
  private static let keyLevel = "level"
  
  private static let keyUnlockedDate = "unlocked_date"
  private static let keyPercentage = "percentage"
  
  // Fields
  public dynamic var character: String = ""
  public dynamic var meaning: String = ""
  public dynamic var level: Int = 0
  
  public dynamic var unlockedDate: Int = 0
  public dynamic var percentage: String = ""
  
  required public init(dict: NSDictionary) {
    super.init()
    
    self.character = (dict[ReviewItem.keyCharacter] as? String) ?? ""
    self.meaning = (dict[ReviewItem.keyMeaning] as? String) ?? ""
    self.level = (dict[ReviewItem.keyLevel] as? Int) ?? 0
    
    self.unlockedDate = (dict[ReviewItem.keyUnlockedDate] as? Int) ?? 0
    self.percentage = (dict[ReviewItem.keyPercentage] as? String) ?? ""
  }

  required public init() {
    super.init()
  }
}

extension ReviewItem: ItemColor {
  public func backgroundColor() -> UIColor? {
    return nil
  }
}

//====================================================================
// MARK - RadicalItem
//====================================================================
public class RadicalItem: ReviewItem {
  
  // Dictionary keys
  private static let keyImage = "image"
  
  // Fields
  public dynamic var imageURL: String = ""
  
  required public init(dict: NSDictionary) {
    super.init(dict: dict)
    self.imageURL = (dict[RadicalItem.keyImage] as? String) ?? ""
  }

  required public init() {
    super.init()
  }
}

extension RadicalItem {
  public override func backgroundColor() -> UIColor? {
    return UIColor(red:0.23, green:0.7, blue:0.96, alpha:1)
  }
}

//====================================================================
// MARK - RadicalItem
//====================================================================
public class KanjiItem: ReviewItem {
  
  // Dictionary keys
  private static let keyOnyomi = "onyomi"
  private static let keyKunyomi = "kunyomi"
  private static let keyNanori  = "nanori"
  private static let keyImportantReading = "important_reading"
  
  // Fields
  public dynamic var onyomi: String = ""
  public dynamic var kunyomi: String = ""
  public dynamic var nanori: String = ""
  public dynamic var importantReading: String = ""
  
  required public init(dict: NSDictionary) {
    super.init(dict: dict)
    self.onyomi = (dict[KanjiItem.keyOnyomi] as? String) ?? ""
    self.kunyomi = (dict[KanjiItem.keyKunyomi] as? String) ?? ""
    self.nanori = (dict[KanjiItem.keyNanori] as? String) ?? ""
    self.importantReading = (dict[KanjiItem.keyImportantReading] as? String) ?? ""
  }
  
  required public init() {
    super.init()
  }
}

extension KanjiItem {
  public override func backgroundColor() -> UIColor? {
    return UIColor(red:0.95, green:0, blue:0.63, alpha:1)
  }
}

//====================================================================
// MARK - VocabItem
//====================================================================
public class VocabItem: ReviewItem {
  
  // Dictionary keys
  private static let keyKana = "kana"
  
  // Fields
  public dynamic var kana: String = ""
  
  required public init(dict: NSDictionary) {
    super.init(dict: dict)
    self.kana = (dict[VocabItem.keyKana] as? String) ?? ""
  }
  
  required public init() {
    super.init()
  }
}

extension VocabItem {
  public override func backgroundColor() -> UIColor? {
    return UIColor(red:0.63, green:0, blue:0.95, alpha:1)
  }
}

