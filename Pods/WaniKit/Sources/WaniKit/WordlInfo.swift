//
//  WordlInfo.swift
//  Pods
//
//  Created by Andriy K. on 2/17/16.
//
//

import Foundation

public struct WordInfo {
  
  // Dictionary keys
  private static let keyCharacter = "character"
  private static let keyKana = "kana"
  private static let keyMeaning = "meaning"
  private static let keyLevel = "level"
  
  private static let keyUserSpecific = "user_specific"
  
  public var character: String
  public var kana: String?
  public var meaning: String?
  public var level: Int
  
  public var userSpecific: UserSpecific?
}

extension WordInfo: DictionaryInitialization {
  
  public init(dict: NSDictionary) {
    character = dict[WordInfo.keyCharacter] as! String
    meaning = dict[WordInfo.keyMeaning] as? String
    kana = dict[WordInfo.keyKana] as? String
    level = dict[WordInfo.keyLevel] as! Int
    
    if let userSpecificDict = dict[WordInfo.keyUserSpecific] as? NSDictionary {
      userSpecific = UserSpecific(dict: userSpecificDict)
    }
  }
}