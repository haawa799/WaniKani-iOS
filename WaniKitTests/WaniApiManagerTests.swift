//
//  WaniApiManagerTests.swift
//  WaniKani
//
//  Created by Andriy K. on 9/16/15.
//  Copyright © 2015 Andriy K. All rights reserved.
//

import XCTest
@testable import WaniKit

let testApiKey = "69b9b1f682946cbc42d251f41f2863d7"

class WaniApiManagerTests: XCTestCase {
  
  var apiManager: WaniApiManager!
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    apiManager = WaniApiManager.sharedInstance()
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
    apiManager = nil
  }
  
  func testInstanceNotNil() {
    XCTAssertNotNil(apiManager)
  }
  
  func testApiKeySetup() {
    let oldKey = apiManager.apiKey()
    
    apiManager.setApiKey(testApiKey)
    XCTAssertEqual(testApiKey, apiManager.apiKey())
    
    apiManager.setApiKey(oldKey)
    XCTAssertEqual(oldKey, apiManager.apiKey())
  }
}
