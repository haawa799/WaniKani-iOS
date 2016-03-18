//
//  DoubleProgressLevelModel.swift
//  WaniKani
//
//  Created by Andriy K. on 3/18/16.
//  Copyright © 2016 Andriy K. All rights reserved.
//

import Foundation

struct DoubleProgressLevelModel: DoubleProgressBarLevelDataSource {
  
  private let levelStr: String
  
  init() {
    let level = 19
    levelStr = "\(level)"
  }
  
}

// MARK: - DoubleProgressBarLevelDataSource
extension DoubleProgressLevelModel {
  var levelString: String { return levelStr }
}