//
//  ItemUserSpecific.swift
//  WaniKani
//
//  Created by Andriy K. on 2/18/16.
//  Copyright © 2016 Andriy K. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

public class ItemUserSpecific: Object {
  
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
  
}