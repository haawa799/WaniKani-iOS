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
  
  private let levelStr: String
  
  init() {
    let level = 19
    let topMax = 25
    let topCur = 12
    let botMax = 30
    let botCur = 20
    
    levelStr = "\(level)"
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