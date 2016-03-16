//
//  TestApplicationCoordinator.swift
//  WaniKani
//
//  Created by Andriy K. on 3/16/16.
//  Copyright © 2016 Andriy K. All rights reserved.
//

import XCTest
@testable import WaniKani

class ApplicationCoordinatorTests: XCTestCase {
  
  let frame = CGRect(x: 0, y: 0, width: 320, height: 640)
  
  var window: UIWindow!
  var appCoordinator: ApplicationCoordinator!
  
}


// MARK: - Setup
extension ApplicationCoordinatorTests {
  
  override func setUp() {
    super.setUp()
    
    window = UIWindow(frame: frame)
    appCoordinator = ApplicationCoordinator(window: window)
  }
  
  override func tearDown() {
    super.tearDown()
    
    window = nil
    appCoordinator = nil
  }
  
}

// MARK: - Tests
extension ApplicationCoordinatorTests {
  
  func testCreation() {
    XCTAssertNotNil(appCoordinator)
  }
  
  func testChildrenCoordinators() {
    XCTAssertEqual(appCoordinator.childrenCoordinators.count, 1)
  }
  
  func testWindowRootVCNotSet() {
    XCTAssertNotEqual(appCoordinator.rootViewController, window.rootViewController)
  }
  
  func testStart() {
    appCoordinator.start()
    XCTAssertEqual(appCoordinator.rootViewController, window.rootViewController)
  }
  
}
