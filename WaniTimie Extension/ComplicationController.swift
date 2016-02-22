//
//  ComplicationController.swift
//  WaniTimie Extension
//
//  Created by Andriy K. on 2/18/16.
//  Copyright © 2016 Andriy K. All rights reserved.
//

import ClockKit
import DataKitWatch


class ComplicationController: NSObject, CLKComplicationDataSource {
  
  var myDelegate: ExtensionDelegate {
    return WKExtension.sharedExtension().delegate as! ExtensionDelegate
  }
  
  let tempKanji: KanjiMainData = {
    var q = KanjiMainData()
    q.character = "京"
    q.meaning = "capital"
    return q
  }()
  
  var basicList: [KanjiMainData] {
    return dataManager.currentLevel?.kanji ?? [KanjiMainData]()
  }
  
  //
  func futureItems(date: NSDate, numberOfItems: Int, limit: Int, endDate: NSDate) -> [(KanjiMainData, NSDate)] {
    
    let numberOfItemsInBasicList = basicList.count
    var array = [(KanjiMainData, NSDate)]()
    guard numberOfItemsInBasicList > 0 else { return array }
    
    let periodInSeconds = endDate.timeIntervalSinceDate(date)
    let step = UInt(periodInSeconds / NSTimeInterval(numberOfItems))
    
    var previousDate = date
    
    for i in 0..<numberOfItems {
      
      if array.count < limit {
        let basicIndex = i % numberOfItemsInBasicList
        let kanji = basicList[basicIndex]
        
        let itemDate = previousDate.plusSeconds(step)
        previousDate = itemDate
        
        let item = (kanji, itemDate)
        array.append(item)
      } else {
        break
      }
    }
    return array
  }
  
  func pastItemsItems(date: NSDate, numberOfItems: Int, limit: Int, beginDate: NSDate) -> [(KanjiMainData, NSDate)] {
    
    let numberOfItemsInBasicList = basicList.count
    var array = [(KanjiMainData, NSDate)]()
    guard numberOfItemsInBasicList > 0 else { return array }
    
    let periodInSeconds = date.timeIntervalSinceDate(beginDate)
    let step = UInt(periodInSeconds / NSTimeInterval(numberOfItems))
    
    var previousDate = date
    
    for i in 0..<numberOfItems {
      
      if array.count < limit {
        let basicIndex = i % numberOfItemsInBasicList
        let kanji = basicList[basicIndex]
        
        let itemDate = previousDate.minusSeconds(step)
        previousDate = itemDate
        
        let item = (kanji, itemDate)
        array.append(item)
      } else {
        break
      }
    }
    return array
  }
  
  //
  
  
  func getSupportedTimeTravelDirectionsForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTimeTravelDirections) -> Void) {
    handler([.Backward,.Forward])
  }
  
  func getTimelineStartDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
    let c = NSDate()
    handler(c.minusMinutes(c.minute).minusHours(36))
  }
  
  func getTimelineEndDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
    let c = NSDate()
    handler(c.minusMinutes(c.minute).plusHours(36))
  }
  
  func getPrivacyBehaviorForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationPrivacyBehavior) -> Void) {
    handler(.ShowOnLockScreen)
  }
  
  // MARK: - Timeline Population
  
  func getCurrentTimelineEntryForComplication(complication: CLKComplication, withHandler handler: ((CLKComplicationTimelineEntry?) -> Void)) {
    // Call the handler with the current timeline entry
    
    if basicList.count == 0 {
      myDelegate.setupWatchConnectivity()
    }
    
    guard let kanji = basicList.first else { handler(nil); return }
    let template = complicationTemplate(complication.family, kanji: kanji)
    let entry = CLKComplicationTimelineEntry(date: NSDate(), complicationTemplate: template)
    
    handler(entry)
  }
  
  func getTimelineEntriesForComplication(complication: CLKComplication, beforeDate date: NSDate, limit: Int, withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
    // Call the handler with the timeline entries prior to the given date
    let items = pastItemsItems(date, numberOfItems: 36, limit: limit, beginDate: date.minusMinutes(date.minute).minusHours(36)).reverse()
    let entries = items.map { (item) -> CLKComplicationTimelineEntry in
      let template = complicationTemplate(complication.family, kanji: item.0)
      let entrie = CLKComplicationTimelineEntry(date: item.1, complicationTemplate: template)
      return entrie
    }
    handler(entries)
  }
  
  func getTimelineEntriesForComplication(complication: CLKComplication, afterDate date: NSDate, limit: Int, withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
    // Call the handler with the timeline entries after to the given date
    let items = futureItems(date, numberOfItems: 36, limit: limit, endDate: date.minusMinutes(date.minute).plusHours(36))
    let entries = items.map { (item) -> CLKComplicationTimelineEntry in
      let template = complicationTemplate(complication.family, kanji: item.0)
      let entrie = CLKComplicationTimelineEntry(date: item.1, complicationTemplate: template)
      return entrie
    }
    handler(entries)
  }
  
  // MARK: - Update Scheduling
  
  func getNextRequestedUpdateDateWithHandler(handler: (NSDate?) -> Void) {
    // Call the handler with the date when you would next like to be given the opportunity to update your complication content
    let c = NSDate()
    handler(c.plusHours(36))
  }
  
  // MARK: - Placeholder Templates
  
  func getPlaceholderTemplateForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTemplate?) -> Void) {
    // This method will be called once per supported complication, and the results will be cached
    handler(complicationTemplate(complication.family, kanji: tempKanji))
  }
  
}

extension ComplicationController {
  
  func complicationTemplate(family: CLKComplicationFamily, kanji: KanjiMainData) -> CLKComplicationTemplate {
    
    let color = UIColor(red:0.99, green:0, blue:0.66, alpha:1)
    
    switch family {
    case .CircularSmall:
      let t = CLKComplicationTemplateCircularSmallSimpleText()
      t.tintColor = color
      t.textProvider = CLKSimpleTextProvider(text: kanji.character)
      return t
    case .ModularLarge:
      let t = CLKComplicationTemplateModularLargeTallBody()
      t.tintColor = color
      t.bodyTextProvider = CLKSimpleTextProvider(text: "==[ \(kanji.character) ]==")
      t.headerTextProvider = CLKSimpleTextProvider(text: kanji.meaning)
      return t
    case .ModularSmall:
      let t = CLKComplicationTemplateModularSmallSimpleText()
      t.tintColor = color
      t.textProvider = CLKSimpleTextProvider(text: kanji.character)
      return t
    case .UtilitarianSmall:
      let t = CLKComplicationTemplateUtilitarianSmallRingText()
      t.tintColor = color
      t.textProvider = CLKSimpleTextProvider(text: kanji.character)
      t.fillFraction = 0
      return t
    case .UtilitarianLarge:
      let t = CLKComplicationTemplateUtilitarianLargeFlat()
      t.tintColor = color
      t.textProvider = CLKSimpleTextProvider(text: "\(kanji.character) \(kanji.meaning)")
      return t
    }
  }
  
}

