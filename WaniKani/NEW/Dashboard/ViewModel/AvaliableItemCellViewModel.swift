//
//  AvaliableItemCellViewModel.swift
//  WaniKani
//
//  Created by Andriy K. on 3/21/16.
//  Copyright © 2016 Andriy K. All rights reserved.
//

import UIKit

struct AvaliableItemCellViewModel: AvaliableItemCellDataSource {
  
  private let numberOfReviewsForMaxPower = 300
  private let rightLabelColor: UIColor
  private let leftTitleString: String
  private let rightTitleString: String
  private let isDisclosureVisible: Bool
  
  init() {
    
    let numberOfReviews = 0
    let power = min(CGFloat(numberOfReviews)/CGFloat(numberOfReviewsForMaxPower), 1)
    rightLabelColor = UIColor.colorForPowerLevel(power)
    
    leftTitleString = "Reviews"
    rightTitleString = "\(numberOfReviews)"
    isDisclosureVisible = (numberOfReviews > 0)
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
  
  var rightTextColor: UIColor {
    return rightLabelColor
  }
  
  var disclosureVisible: Bool {
    return isDisclosureVisible
  }
}
