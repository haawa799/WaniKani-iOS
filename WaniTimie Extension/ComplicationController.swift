//
//  ComplicationController.swift
//  WaniTimie Extension
//
//  Created by Andriy K. on 2/17/16.
//  Copyright © 2016 Andriy K. All rights reserved.
//

import ClockKit

struct Item {
  var A: String
  var B: String
  var C: String?
}

var numberOfItems: Int {
  return originalItems.count
}

let originalItems: [Item] = {
  
  let q = [
    Item(A: "A",B: "",C: "0"),
    Item(A: "B",B: "",C: "1"),
    Item(A: "C",B: "",C: "2"),
    Item(A: "D",B: "",C: "3"),
    Item(A: "E",B: "",C: "4"),
    Item(A: "F",B: "",C: "5"),
    Item(A: "G",B: "",C: "6"),
    Item(A: "H",B: "",C: "7"),
    Item(A: "I",B: "",C: "8"),
    Item(A: "J",B: "",C: "9"),
    Item(A: "K",B: "",C: "10"),
    Item(A: "L",B: "",C: "11"),
    Item(A: "M",B: "",C: "12"),
    Item(A: "N",B: "",C: "13"),
    Item(A: "O",B: "",C: "14"),
    Item(A: "P",B: "",C: "15"),
    Item(A: "Q",B: "",C: "16"),
    Item(A: "R",B: "",C: "17"),
    Item(A: "S",B: "",C: "18"),
    Item(A: "T",B: "",C: "19"),
    Item(A: "U",B: "",C: "20"),
    Item(A: "V",B: "",C: "21"),
    Item(A: "W",B: "",C: "22"),
    Item(A: "X",B: "",C: "23"),
    Item(A: "Y",B: "",C: "24"),
    Item(A: "Z",B: "",C: "25")
  ]
  return q
  
  //  var items = [Item]()
  //  for var i = 0; i < numberOfItems; i++ {
  //    let item = Item(A: "#\(i)",B: "",C: nil)
  //    items.append(item)
  //  }
  //  return items
}()



//class ComplicationController: NSObject, CLKComplicationDataSource {
//  
//  // MARK: Register
//  func getPlaceholderTemplateForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTemplate?) -> Void) {
//
//    if complication.family == .UtilitarianLarge {
//      let largeFlat = CLKComplicationTemplateUtilitarianLargeFlat()
//      largeFlat.textProvider = CLKSimpleTextProvider(text: "Long text", shortText:"QQ")
//      largeFlat.imageProvider = nil
//      handler(largeFlat)
//    }
//  }
//  
//  // MARK: Refresh Data
//  func getNextRequestedUpdateDateWithHandler(handler: (NSDate?) -> Void) {
//    let tideConditions = TideConditions.loadConditions()
//    if let waterLevel = tideConditions.waterLevels.last {
//      handler(waterLevel.date)
//    } else {
//      // Refresh Now!
//      handler(NSDate())
//    }
//  }
//  
//}
