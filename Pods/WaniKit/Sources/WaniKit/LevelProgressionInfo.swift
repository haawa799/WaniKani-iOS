//
//  LevelProgressionInfo.swift
//  Pods
//
//  Created by Andriy K. on 12/10/15.
//
//

import Foundation

public struct LevelProgressionInfo {
  
  // Dictionary keys
  private static let keyRadicalsProgress = "radicals_progress"
  private static let keyRadicalsTotal = "radicals_total"
  private static let keyKanjiProgress = "kanji_progress"
  private static let keyKanjiTotal = "kanji_total"
  //
  
  public var radicalsProgress: Int?
  public var radicalsTotal: Int?
  public var kanjiProgress: Int?
  public var kanjiTotal: Int?
  
}

extension LevelProgressionInfo: DictionaryInitialization {
  
  public init(dict: NSDictionary) {
    radicalsProgress = (dict[LevelProgressionInfo.keyRadicalsProgress] as? Int)
    radicalsTotal = (dict[LevelProgressionInfo.keyRadicalsTotal] as? Int)
    kanjiProgress = (dict[LevelProgressionInfo.keyKanjiProgress] as? Int)
    kanjiTotal = (dict[LevelProgressionInfo.keyKanjiTotal] as? Int)
  }
  
}
