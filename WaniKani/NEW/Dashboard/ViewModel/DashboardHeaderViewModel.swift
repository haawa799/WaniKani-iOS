//
//  DashboardHeaderViewModel.swift
//  WaniKani
//
//  Created by Andriy K. on 3/22/16.
//  Copyright © 2016 Andriy K. All rights reserved.
//

import Foundation

struct DashboardHeaderViewModel: SingleTitleViewModel {
  
  private let titleString: String
  
  init(title: String) {
    titleString = title
  }
}


// MARK: - SingleTitleViewModel
extension DashboardHeaderViewModel {
  var title: String {
    return titleString
  }
}