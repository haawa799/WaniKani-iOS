//
//  DashboardCoordinator.swift
//  WaniKani
//
//  Created by Andriy K. on 3/16/16.
//  Copyright © 2016 Andriy K. All rights reserved.
//

import XCTest
@testable import WaniKani

class DashboardCoordinatorTests: XCTestCase {
  
  var navigationController: UINavigationController!
  var dashboardCoordinator: DashboardCoordinator!
  
}


// MARK: - Setup
extension DashboardCoordinatorTests {
  
  override func setUp() {
    super.setUp()
    navigationController = UINavigationController()
    dashboardCoordinator = DashboardCoordinator(presenter: navigationController)
  }
  
  override func tearDown() {
    super.tearDown()
    navigationController = nil
    dashboardCoordinator = nil
  }
  
}

// MARK: - Tests
extension DashboardCoordinatorTests {
  
  func testCreation() {
    XCTAssertNotNil(dashboardCoordinator)
  }
  
  func testChildrenCoordinators() {
    XCTAssertEqual(dashboardCoordinator.childrenCoordinators.count, 0)
  }
  
  func testNavigationStackEmpty() {
    XCTAssertEqual(dashboardCoordinator.presenter.viewControllers.count, 0)
  }
  
  func testNavigationStackNotEmptyAfterStart() {
    dashboardCoordinator.start()
    XCTAssertNotEqual(dashboardCoordinator.presenter.viewControllers.count, 0)
  }
  
}