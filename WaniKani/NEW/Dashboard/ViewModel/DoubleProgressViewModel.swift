//
//  DoubleProgressBarViewModel.swift
//  WaniKani
//
//  Created by Andriy K. on 3/18/16.
//  Copyright © 2016 Andriy K. All rights reserved.
//

import UIKit

struct DoubleProgressViewModel: DoubleProgressBarProgressDataSource {
  
  private let topProgressString: String
  private let botProgressString: String
  
  private let topProgress: CGFloat
  private let botProgress: CGFloat
  
  init(progression: LevelProgression) {
    let topMax = progression.kanjiTotal
    let topCur = progression.kanjiProgress
    let botMax = progression.radicalsTotal
    let botCur = progression.radicalsProgress
    
    topProgressString = "\(topCur)/\(topMax)"
    botProgressString = "\(botCur)/\(botMax)"
    
    topProgress = CGFloat(topCur)/CGFloat(topMax)
    botProgress = CGFloat(botCur)/CGFloat(botMax)
  }
  
}

// MARK: - DoubleProgressBarProgressDataSource
extension DoubleProgressViewModel {
  var topTitle: String { return topProgressString }
  var botTitle: String { return botProgressString }
  var topProgressPercentage: CGFloat { return topProgress }
  var botProgressPercentage: CGFloat { return botProgress }
}