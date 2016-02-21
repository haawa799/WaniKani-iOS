//
//  InterfaceController.swift
//  WaniTimie Extension
//
//  Created by Andriy K. on 2/18/16.
//  Copyright © 2016 Andriy K. All rights reserved.
//

import WatchKit
import Foundation
import DataKitWatch

class InterfaceController: WKInterfaceController {
  
  // MARK: - Outlets
  @IBOutlet var label: WKInterfaceLabel!
  @IBOutlet var table: WKInterfaceTable! {
    didSet {
      updateTableView()
    }
  }
  
}

// MARK: - WKInterfaceController
extension InterfaceController {
  
  override func awakeWithContext(context: AnyObject?) {
    super.awakeWithContext(context)
  }
  
  override func willActivate() {
    super.willActivate()
    dataManager.registerObjectForNotification(self, selector: Selector("dataReceived"), notificationName: DataManager.Notification.currentLevelUpdate)
  }
  
  override func willDisappear() {
    super.willDisappear()
    dataManager.removeObserver(self)
  }
  
}

// Update UI
extension InterfaceController {
  
  func updateTableView() {
    
    guard let levelData = dataManager.currentLevel else { return }
    let kanji = levelData.kanji
    guard kanji.count > 0 else { return }
    setTitle("Kanji lvl\(kanji[0].level)")
    
    guard let table = table else { return }
    
    table.setNumberOfRows(kanji.count,
      withRowType: KanjiRowController.cellIdentifier)
    
    for (index, element) in kanji.enumerate() {
      let controller = table.rowControllerAtIndex(index)
        as! KanjiRowController
      controller.kanjiLabel.setText(element.character)
      controller.meaningLabel.setText(element.meaning)
      controller.readingLabel.setText("\(element.on),\(element.kun)")
    }
  }
  
}

// Notifications
extension InterfaceController {
  
  func dataReceived() {
    updateTableView()
  }
}
