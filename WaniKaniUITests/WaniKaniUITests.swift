//
//  WaniKaniUITests.swift
//  WaniKaniUITests
//
//  Created by Andriy K. on 12/17/15.
//  Copyright © 2015 Andriy K. All rights reserved.
//

import XCTest

class WaniKaniUITests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    
    continueAfterFailure = false
    
    let app = XCUIApplication()
    app.launchEnvironment = ["isUITest": "\(true)"]
    setupSnapshot(app)
    app.launch()
  }
  
  func test0() {
    
//    
    let app = XCUIApplication()
    
    sleep(2)
    
    snapshot("5 Setup Login", waitForLoadingIndicator: false)
    
    app.buttons["Login"].tap()
    
    sleep(4)

    authentificate(app)
    
    // Parsing for API key
    sleep(8)
    
    
//    snapshot("Setup Notifications", waitForLoadingIndicator: false)
    
    app.buttons["Setup notifications"].tap()
    sleep(1)
    
    
    app.buttons["Close"].tap()
    sleep(1)
    app.navigationBars["WaniKani.NotificationsSetupVC"].buttons["Next"].tap()
    sleep(1)
    
    
//    snapshot("Setup GameCenter", waitForLoadingIndicator: false)
    
    app.navigationBars["WaniKani.GameCenterSetupVC"].buttons["Done"].tap()
    sleep(1)
    
    sleep(5)
    
    snapshot("3 Study Queue", waitForLoadingIndicator: false)
    
    app.tabBars.buttons["Settings"].tap()
    
    sleep(1)
    
    
    let cellsQuery = app.collectionViews.cells
    cellsQuery.elementBoundByIndex(1).otherElements["switch"].tap()
    cellsQuery.elementBoundByIndex(2).otherElements["switch"].tap()
    cellsQuery.elementBoundByIndex(3).otherElements["switch"].tap()
    

    sleep(1)
    snapshot("4 Settings", waitForLoadingIndicator: false)
    
    app.tabBars.buttons["Dashboard"].tap()
    
    
//    app.collectionViews.cells.elementBoundByIndex(0).tap()
//    
//    sleep(3)
//    
//    authentificate(app)
//    
//    
//    sleep(4)
//    
//    snapshot("Lessons", waitForLoadingIndicator: false)
//
//    sleep(1)
//    
//    
//    app.toolbars.buttons["Submit"].tap()
    
    
    sleep(1)
    
    app.collectionViews.cells.elementBoundByIndex(1).tap()
    
    sleep(3)
    
    authentificate(app)
    
    sleep(6)
    
    snapshot("1 Review", waitForLoadingIndicator: false)
    
    sleep(2)
    
    app.toolbars.buttons["Done"].tap()
    app.toolbars.buttons["strokesButton"].tap()
    
    sleep(2)
    
    snapshot("2 Review stroke order", waitForLoadingIndicator: false)
    app.childrenMatchingType(.Window).elementBoundByIndex(0).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).elementBoundByIndex(1).childrenMatchingType(.Other).element.childrenMatchingType(.Other).elementBoundByIndex(2).childrenMatchingType(.Button).element.tap()
    
    sleep(1)
    
    app.toolbars.buttons["Submit"].tap()
    
  }
  
  private func authentificate(app: XCUIApplication) {
    
    app.textFields.elementBoundByIndex(0).tap()
    sleep(1)
    app.textFields.elementBoundByIndex(0).typeText("paukan")
  
    
    sleep(2)
    app.toolbars.buttons["Forward"].tap()
    sleep(2)
    app.secureTextFields.elementBoundByIndex(0).typeText("1234567890\r")
  }
  
}
