//
//  KanjiCell.swift
//  WaniKani-Kanji-Strokes
//
//  Created by Andriy K. on 12/28/15.
//  Copyright © 2015 Andriy K. All rights reserved.
//

import UIKit
import WaniKit

class KanjiCell: UICollectionViewCell {
  
  @IBOutlet weak var kanjiLabel: UILabel!
  @IBOutlet weak var atarashiMark: UIImageView!
  @IBOutlet weak var lockedBackground: UIImageView!
  
  let burnedColor = UIColor(red:0.33, green:0.33, blue:0.33, alpha:1)
  let numberOfDaysToCountAsNew = 5
  
  func setupWithKanji(kanji: KanjiInfo) {
    
    kanjiLabel?.text = kanji.character
    
    guard let userSpecific = kanji.userSpecific else { return }
    
    if userSpecific.burned {
      backgroundColor = burnedColor
    }
    
    if let unlockDate = userSpecific.unlockedDate {
      lockedBackground?.hidden = true
      
      if (unlockDate.numberOfDaysUntilDateTime(NSDate()) <= numberOfDaysToCountAsNew) {
        atarashiMark?.hidden = false
      }
    }
    
  }
  
}

extension NSDate {
  func numberOfDaysUntilDateTime(toDateTime: NSDate, inTimeZone timeZone: NSTimeZone? = nil) -> Int {
    let calendar = NSCalendar.currentCalendar()
    if let timeZone = timeZone {
      calendar.timeZone = timeZone
    }
    
    var fromDate: NSDate?, toDate: NSDate?
    
    calendar.rangeOfUnit(.Day, startDate: &fromDate, interval: nil, forDate: self)
    calendar.rangeOfUnit(.Day, startDate: &toDate, interval: nil, forDate: toDateTime)
    
    let difference = calendar.components(.Day, fromDate: fromDate!, toDate: toDate!, options: [])
    return difference.day
  }
}