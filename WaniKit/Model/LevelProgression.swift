//
//  LevelProgression.swift
//  WaniKani
//
//  Created by Andriy K. on 9/30/15.
//  Copyright © 2015 Andriy K. All rights reserved.
//

import RealmSwift

public class LevelProgression: Object {
  
  // Dictionary keys
  private static let keyRadicalsProgress = "radicals_progress"
  private static let keyRadicalsTotal = "radicals_total"
  private static let keyKanjiProgress = "kanji_progress"
  private static let keyKanjiTotal = "kanji_total"
  //
  
  public dynamic var radicalsProgress: Int = 0
  public dynamic var radicalsTotal: Int = 0
  public dynamic var kanjiProgress: Int = 0
  public dynamic var kanjiTotal: Int = 0
}


extension LevelProgression: DictionaryConvertable {
  class func objectFromDictionary(dict: NSDictionary) -> LevelProgression? {
    let levelProgression = LevelProgression()
    
    levelProgression.radicalsProgress = (dict[keyRadicalsProgress] as? Int) ?? 0
    levelProgression.radicalsTotal = (dict[keyRadicalsTotal] as? Int) ?? 0
    levelProgression.kanjiProgress = (dict[keyKanjiProgress] as? Int) ?? 0
    levelProgression.kanjiTotal = (dict[keyKanjiTotal] as? Int) ?? 0
    
    return levelProgression
  }
}