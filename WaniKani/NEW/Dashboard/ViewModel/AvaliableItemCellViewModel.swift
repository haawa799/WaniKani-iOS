//
//  AvaliableItemCellViewModel.swift
//  WaniKani
//
//  Created by Andriy K. on 3/21/16.
//  Copyright © 2016 Andriy K. All rights reserved.
//

import Foundation

struct AvaliableItemCellViewModel: AvaliableItemCellDataSource {
  private let leftTitleString: String
  private let rightTitleString: String
  private let isDisclosureVisible: Bool
  
  init() {
    leftTitleString = "Reviews"
    rightTitleString = "163"
    isDisclosureVisible = true
  }
}


// MARK: -
extension AvaliableItemCellViewModel {
  var leftTitle: String {
    return leftTitleString
  }
  
  var rightTitle: String {
    return rightTitleString
  }
  
  var disclosureVisible: Bool {
    return isDisclosureVisible
  }
}
