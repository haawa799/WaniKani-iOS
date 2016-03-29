//
//  SettingsScriptCellViewModel.swift
//  WaniKani
//
//  Created by Andriy K. on 3/28/16.
//  Copyright © 2016 Andriy K. All rights reserved.
//

import Foundation

struct SettingsScriptCellViewModel: SettingsScriptCellDataSource {
  
  private let titleString: String
  private let state: Bool
  
  init(setting: Setting) {
    titleString = setting.description ?? ""
    state = setting.enabled
  }
  
}

extension SettingsScriptCellViewModel {
  
  var switchState: Bool {
    return state
  }
  
  var title: String {
    return titleString
  }
  
}