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
    
    
    let app = XCUIApplication()

    sleep(2)
    
    snapshot("Setup Login", waitForLoadingIndicator: true)
    
    app.buttons.elementBoundByIndex(1).tap()
    
    sleep(4)

    authentificate(app)

    //
    
    
    //
    
    // Parsing for API key
    sleep(6)
    
    
    snapshot("Setup Notifications", waitForLoadingIndicator: true)
    
    app.buttons["Setup notifications"].tap()
    sleep(1)
    
    
    app.buttons["Close"].tap()
    sleep(1)
    app.navigationBars["WaniKani.NotificationsSetupVC"].buttons["Next"].tap()
    sleep(1)
    
    
    snapshot("Setup GameCenter", waitForLoadingIndicator: true)
    
    app.navigationBars["WaniKani.GameCenterSetupVC"].buttons["Done"].tap()
    sleep(1)
    
    sleep(5)
    
    snapshot("Study Queue", waitForLoadingIndicator: true)
    
    app.tabBars.buttons["Settings"].tap()
    
    sleep(1)
    
    
    let cellsQuery = app.collectionViews.cells
    cellsQuery.elementBoundByIndex(1).otherElements["switch"].tap()
    cellsQuery.elementBoundByIndex(2).otherElements["switch"].tap()
    cellsQuery.elementBoundByIndex(3).otherElements["switch"].tap()
    

    sleep(1)
    snapshot("Settings", waitForLoadingIndicator: true)
    
    app.tabBars.buttons["Dashboard"].tap()
    
    app.collectionViews.cells.elementBoundByIndex(0).tap()
    
    sleep(3)
    
    authentificate(app)
    
    
    sleep(3)
    
    snapshot("Lessons", waitForLoadingIndicator: true)

    sleep(1)
    
    
    app.toolbars.buttons["Submit"].tap()
    
    
    sleep(1)
    
    app.collectionViews.cells.elementBoundByIndex(1).tap()
    
    sleep(3)
    
    snapshot("Review", waitForLoadingIndicator: false)
    
    sleep(3)
    app.toolbars.buttons["Done"].tap()
    sleep(1)
    
    app.toolbars.buttons["Submit"].tap()
    
    sleep(1)
    
    app.tabBars.buttons["Browser"].tap()
    
    sleep(4)
    
    authentificate(app)
    
    snapshot("Browser", waitForLoadingIndicator: true)
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
