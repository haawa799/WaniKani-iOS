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