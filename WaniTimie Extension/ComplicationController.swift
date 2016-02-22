//
//  ComplicationController.swift
//  WaniTimie Extension
//
//  Created by Andriy K. on 2/18/16.
//  Copyright © 2016 Andriy K. All rights reserved.
//

import ClockKit


// guard let levelData = dataManager.currentLevel else { return }
class ComplicationController: NSObject, CLKComplicationDataSource {
  
  // MARK: - Timeline Configuration
  
  
  func getSupportedTimeTravelDirectionsForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTimeTravelDirections) -> Void) {
    handler([.Forward, .Backward])
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
    
    let template = complicationTemplate(complication.family)
    let entry = CLKComplicationTimelineEntry(date: NSDate(), complicationTemplate: template)
    
    handler(entry)
  }
  
  func getTimelineEntriesForComplication(complication: CLKComplication, beforeDate date: NSDate, limit: Int, withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
    // Call the handler with the timeline entries prior to the given date
    handler(nil)
  }
  
  func getTimelineEntriesForComplication(complication: CLKComplication, afterDate date: NSDate, limit: Int, withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
    // Call the handler with the timeline entries after to the given date
    handler(nil)
  }
  
  // MARK: - Update Scheduling
  
  func getNextRequestedUpdateDateWithHandler(handler: (NSDate?) -> Void) {
    // Call the handler with the date when you would next like to be given the opportunity to update your complication content
    handler(nil);
  }
  
  // MARK: - Placeholder Templates
  
  func getPlaceholderTemplateForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTemplate?) -> Void) {
    // This method will be called once per supported complication, and the results will be cached
    handler(complicationTemplate(complication.family))
  }
  
}

extension ComplicationController {
  
  func complicationTemplate(family: CLKComplicationFamily) -> CLKComplicationTemplate {
    
    let kanji = "京"
    let meaning = "capital"
    let color = UIColor(red:0.99, green:0, blue:0.66, alpha:1)
    
    switch family {
    case .CircularSmall:
      let t = CLKComplicationTemplateCircularSmallSimpleText()
      t.tintColor = color
      t.textProvider = CLKSimpleTextProvider(text: kanji)
      return t
    case .ModularLarge:
      let t = CLKComplicationTemplateModularLargeTallBody()
      t.tintColor = color
      t.bodyTextProvider = CLKSimpleTextProvider(text: "==[ \(kanji) ]==")
      t.headerTextProvider = CLKSimpleTextProvider(text: meaning)
      return t
    case .ModularSmall:
      let t = CLKComplicationTemplateModularSmallSimpleText()
      t.tintColor = color
      t.textProvider = CLKSimpleTextProvider(text: kanji)
      return t
    case .UtilitarianSmall:
      let t = CLKComplicationTemplateUtilitarianSmallRingText()
      t.tintColor = color
      t.textProvider = CLKSimpleTextProvider(text: kanji)
      t.fillFraction = 0
      return t
    case .UtilitarianLarge:
      let t = CLKComplicationTemplateUtilitarianLargeFlat()
      t.tintColor = color
      t.textProvider = CLKSimpleTextProvider(text: "\(kanji) \(meaning)")
      return t
    }
  }
  
}

