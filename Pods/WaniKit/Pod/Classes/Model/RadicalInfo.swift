//
//  RadicalInfo.swift
//  Pods
//
//  Created by Andriy K. on 2/15/16.
//
//

import Foundation

public struct RadicalInfo {
  
  // Dictionary keys
  private static let keyCharacter = "character"
  private static let keyMeaning = "meaning"
  private static let keyImage = "image"
  private static let keyLevel = "level"
  
  private static let keyUserSpecific = "user_specific"
  
  public var character: String?
  public var meaning: String?
  public var image: String?
  public var level: Int
  
  public var userSpecific: UserSpecific?
}

extension RadicalInfo: DictionaryInitialization {
  
  public init(dict: NSDictionary) {
    character = dict[RadicalInfo.keyCharacter] as? String
    meaning = dict[RadicalInfo.keyMeaning] as? String
    image = dict[RadicalInfo.keyImage] as? String
    level = dict[RadicalInfo.keyLevel] as! Int
    
    if let userSpecificDict = dict[RadicalInfo.keyUserSpecific] as? NSDictionary {
      userSpecific = UserSpecific(dict: userSpecificDict)
    }
  }
}
