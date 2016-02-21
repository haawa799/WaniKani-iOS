//
//  KanjiRowController.swift
//  WaniKani
//
//  Created by Andriy K. on 2/20/16.
//  Copyright © 2016 Andriy K. All rights reserved.
//

import WatchKit

class KanjiRowController: NSObject {
  
  static let cellIdentifier = "cell"
  
  @IBOutlet weak var kanjiLabel: WKInterfaceLabel!
  @IBOutlet weak var meaningLabel: WKInterfaceLabel!
  @IBOutlet weak var readingLabel: WKInterfaceLabel!
  
  @IBOutlet var backgroundGroup: WKInterfaceGroup!
}
