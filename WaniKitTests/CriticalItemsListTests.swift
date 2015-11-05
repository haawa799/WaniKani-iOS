//
//  CriticalItemsListTests.swift
//  WaniKani
//
//  Created by Andriy K. on 11/3/15.
//  Copyright © 2015 Andriy K. All rights reserved.
//

import XCTest
@testable import WaniKit
import RealmSwift

class CriticalItemsListTests: XCTestCase {
  
  
  
  let dummyResponse: NSDictionary = {
    let dummyString = "{\"user_information\": {\"username\": \"haawa\", \"gravatar\": \"bd2e9da5bf6c3c5c0e7eb1ff5bf7998e\", \"level\": 9, \"title\": \"Turtles\", \"about\": \"iOS\", \"website\": null, \"twitter\": \"haawa\", \"topics_count\": 2, \"posts_count\": 64, \"creation_date\": 1438687727, \"vacation_date\": null }, \"requested_information\": [{\"type\": \"radical\", \"character\": \"ハ\", \"meaning\": \"fins\", \"image\": null, \"level\": 1, \"percentage\": \"80\"}, {\"type\": \"kanji\", \"character\": \"入\", \"meaning\": \"enter\", \"onyomi\": \"にゅう\", \"kunyomi\": \"はい.る, い.れる\", \"nanori\": null, \"important_reading\": \"onyomi\", \"level\": 1, \"percentage\": \"90\"}, {\"type\": \"vocabulary\", \"character\": \"入る\", \"kana\": \"はいる\", \"meaning\": \"to enter\", \"level\": 1, \"percentage\": \"91\"}, {\"type\": \"radical\", \"character\": null, \"meaning\": \"stick\", \"image\": \"https://s3.amazonaws.com/s3.wanikani.com/images/radicals/802e9542627291d4282601ded41ad16ce915f60f.png\", \"level\": 1, \"percentage\": \"10\"} ] }"
    let data = dummyString.dataUsingEncoding(NSUTF8StringEncoding)!
    let jsonResponse: NSDictionary = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
    return jsonResponse
  }()
  
  var criticalItems: CriticalItemsList!
  
  override func setUp() {
    super.setUp()
    
    let items = dummyResponse["requested_information"] as! NSArray
    criticalItems = CriticalItemsList(array: items)
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  //====================================================================
  // MARK - Radicals
  //====================================================================
  func testNumberOfRadicals() {
    XCTAssertEqual(criticalItems.radicals.count, 2)
  }
  
  func testRadical0() {
    let radicals = criticalItems.radicals
    let radical0 = radicals[0]
    XCTAssertEqual(radical0.imageURL, "")
    XCTAssertEqual(radical0.level, 1)
    XCTAssertEqual(radical0.meaning, "fins")
    XCTAssertEqual(radical0.character, "ハ")
    XCTAssertEqual(radical0.percentage, "80")
    XCTAssertEqual(radical0.unlockedDate, 0)
  }
  
  func testRadical1() {
    let radicals = criticalItems.radicals
    let radical1 = radicals[1]
    XCTAssertEqual(radical1.imageURL, "https://s3.amazonaws.com/s3.wanikani.com/images/radicals/802e9542627291d4282601ded41ad16ce915f60f.png")
    XCTAssertEqual(radical1.level, 1)
    XCTAssertEqual(radical1.meaning, "stick")
    XCTAssertEqual(radical1.character, "")
    XCTAssertEqual(radical1.percentage, "10")
    XCTAssertEqual(radical1.unlockedDate, 0)
  }
  
  //====================================================================
  // MARK - Kanji
  //====================================================================
  func testNumberOfKanji() {
    XCTAssertEqual(criticalItems.kanji.count, 1)
  }
  
  func testKanji0() {
    let kanji = criticalItems.kanji
    let kanji0 = kanji[0]
    XCTAssertEqual(kanji0.level, 1)
    XCTAssertEqual(kanji0.meaning, "enter")
    XCTAssertEqual(kanji0.character, "入")
    
    XCTAssertEqual(kanji0.onyomi, "にゅう")
    XCTAssertEqual(kanji0.kunyomi, "はい.る, い.れる")
    XCTAssertEqual(kanji0.nanori, "")
    XCTAssertEqual(kanji0.importantReading, "onyomi")
    XCTAssertEqual(kanji0.percentage, "90")
    XCTAssertEqual(kanji0.unlockedDate, 0)
  }
  
  //====================================================================
  // MARK - Vocab
  //====================================================================
  func testNumberOfVocab() {
    XCTAssertEqual(criticalItems.vocab.count, 1)
  }
  
  func testVocab0() {
    let vocabs = criticalItems.vocab
    let vocab0 = vocabs[0]
    
    XCTAssertEqual(vocab0.kana, "はいる")
    XCTAssertEqual(vocab0.level, 1)
    XCTAssertEqual(vocab0.meaning, "to enter")
    XCTAssertEqual(vocab0.character, "入る")
    XCTAssertEqual(vocab0.percentage, "91")
    XCTAssertEqual(vocab0.unlockedDate, 0)
  }
}
