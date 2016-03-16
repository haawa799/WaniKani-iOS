//
//  AppDelegateTests.swift
//  WaniKani
//
//  Created by Andriy K. on 3/16/16.
//  Copyright © 2016 Andriy K. All rights reserved.
//

import XCTest
@testable import WaniKani

class AppDelegateTests: XCTestCase {
  
  var appDelegate: AppDelegate!
  
}

// MARK: - Setup
extension AppDelegateTests {
  
  override func setUp() {
    super.setUp()
    appDelegate = AppDelegate()
  }
  
  override func tearDown() {
    super.tearDown()
    appDelegate = nil
  }
  
}

// MARK: - Tests
extension AppDelegateTests {
  
  func testWindowNil() {
    XCTAssertNil(appDelegate.window)
  }
  
  func testdidFinishLaunchingWithOptions() {
    
    appDelegate.application(UIApplication.sharedApplication(), didFinishLaunchingWithOptions: nil)
    XCTAssertNotNil(appDelegate.window)
  }
  
}
