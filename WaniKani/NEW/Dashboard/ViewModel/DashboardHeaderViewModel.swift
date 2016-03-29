//
//  DashboardHeaderViewModel.swift
//  WaniKani
//
//  Created by Andriy K. on 3/22/16.
//  Copyright © 2016 Andriy K. All rights reserved.
//

import UIKit

struct DashboardHeaderViewModel: DashboardHeaderDatasource {
  
  private let titleString: String
  private var color: UIColor?
  
  init(title: String, color: UIColor?) {
    titleString = title
    self.color = color
  }
}


// MARK: - DashboardHeaderDatasource
extension DashboardHeaderViewModel {
  
  var title: String {
    return titleString
  }
  
  var bgColor: UIColor? {
    return self.color
  }
  
}