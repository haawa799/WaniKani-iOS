//
//  swift
//  WaniKani
//
//  Created by Andriy K. on 9/30/15.
//  Copyright © 2015 Andriy K. All rights reserved.
//

import RealmSwift
import WaniKit

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

extension LevelProgression {
  
  func updateWith(levelProgressInfo: LevelProgressionInfo?) {
    guard let levelProgressInfo = levelProgressInfo else { return }
    radicalsProgress = levelProgressInfo.radicalsProgress ?? 0
    radicalsTotal = levelProgressInfo.radicalsTotal ?? 0
    kanjiProgress = levelProgressInfo.kanjiProgress ?? 0
    kanjiTotal = levelProgressInfo.kanjiTotal ?? 0
  }
  
  convenience init(levelProgressInfo: LevelProgressionInfo) {
    self.init()
    updateWith(levelProgressInfo)
  }
  
}