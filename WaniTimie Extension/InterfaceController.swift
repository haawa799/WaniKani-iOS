//
//  InterfaceController.swift
//  WaniTimie Extension
//
//  Created by Andriy K. on 2/18/16.
//  Copyright © 2016 Andriy K. All rights reserved.
//

import WatchKit
import Foundation
import RealmSwift


class InterfaceController: WKInterfaceController {
  
  @IBOutlet var label: WKInterfaceLabel!
  
  
  override func awakeWithContext(context: AnyObject?) {
    super.awakeWithContext(context)
  }
  
  override func willActivate() {
    // This method is called when watch view controller is about to be visible to user
    super.willActivate()
    
  }
  
  override func didDeactivate() {
    // This method is called when watch view controller is no longer visible
    super.didDeactivate()
  }
  
}
