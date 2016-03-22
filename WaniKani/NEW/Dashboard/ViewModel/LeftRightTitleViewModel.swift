//
//  LeftRightTitleViewModel.swift
//  WaniKani
//
//  Created by Andriy K. on 3/22/16.
//  Copyright © 2016 Andriy K. All rights reserved.
//

import Foundation

struct LeftRightTitleViewModel: LeftRightTitleDatasource {
  private let leftTitleString: String
  private let rightTitleString: String
  
  init() {
    leftTitleString = "Next hour"
    rightTitleString = "78"
  }
}

// MARK: - LeftRightTitleDatasource
extension LeftRightTitleViewModel {
  var leftTitle: String {
    return leftTitleString
  }
  
  var rightTitle: String {
    return rightTitleString
  }
}