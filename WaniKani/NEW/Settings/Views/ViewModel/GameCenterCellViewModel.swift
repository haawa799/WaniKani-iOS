//
//  GameCenterCellViewModel.swift
//  WaniKani
//
//  Created by Andriy K. on 3/28/16.
//  Copyright © 2016 Andriy K. All rights reserved.
//

import Foundation

struct GameCenterCellViewModel: SingleTitleViewModel {
  
  private let titleString: String
  
  init(setting: Setting) {
    titleString = setting.description ?? ""
  }
  
}

extension GameCenterCellViewModel {
  
  var title: String {
    return titleString
  }
  
}