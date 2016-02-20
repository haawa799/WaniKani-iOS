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
  
  var levelData: KanjiUpdateObject?
  
  @IBOutlet var label: WKInterfaceLabel!
  @IBOutlet var table: WKInterfaceTable! {
    didSet {
      updateTableView()
    }
  }
  
  
  override func awakeWithContext(context: AnyObject?) {
    super.awakeWithContext(context)
    updateKanjiList()
  }
  
  func updateKanjiList() {
    levelData = NSKeyedUnarchiver.unarchiveObjectWithFile(updatePath) as? KanjiUpdateObject
    
    label?.setText("count: \(levelData?.kanji.count)")
    
    updateTableView()
  }
  
  func updateTableView() {
    guard let kanji = levelData?.kanji else { return }
    
    guard let table = table else { return }
    
    table.setNumberOfRows(kanji.count,
      withRowType: "cell")
    
    for (index, element) in kanji.enumerate() {
      let controller = table.rowControllerAtIndex(index)
        as! KanjiRowController
      controller.kanjiLabel.setText(element.character)
      controller.meaningLabel.setText(element.meaning)
      controller.readingLabel.setText("\(element.on),\(element.kun)")
    }
  }
  
  override func willActivate() {
    // This method is called when watch view controller is about to be visible to user
    super.willActivate()
    updateTableView()
  }
  
  override func didDeactivate() {
    // This method is called when watch view controller is no longer visible
    super.didDeactivate()
  }
  
}
