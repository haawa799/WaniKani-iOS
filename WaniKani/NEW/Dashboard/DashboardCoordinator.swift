//✅
//  DashboardCoordinator.swift
//  WaniKani
//
//  Created by Andriy K. on 3/14/16.
//  Copyright © 2016 Andriy K. All rights reserved.
//

import UIKit

public class DashboardCoordinator: Coordinator, DashboardViewControllerDelegate, ReviewCoordinatorDelegate {
  
  let presenter: UINavigationController
  let dashboardViewController: DashboardViewController
  
  private var reviewCoordinator: ReviewCoordinator?
  private let settingsSuit: SettingsSuit
  
  var canOpenReview: Bool = false
  var canOpenLessons: Bool = false
  
  let dataProvider = DataProvider()
  
  public init(presenter: UINavigationController, settingsSuit: SettingsSuit) {
    self.settingsSuit = settingsSuit
    self.presenter = presenter
    dashboardViewController = DashboardViewController.instantiateViewController()
    let tabItem: UITabBarItem = UITabBarItem(title: "Dashboard", image: UIImage(named: "dashboard"), selectedImage: nil)
    presenter.tabBarItem = tabItem
  }
  
  deinit {
    unregisterFromDataNotifications()
  }
  
  func start() {
    registerForDataNotifications()
    dashboardViewController.delegate = self
    presenter.pushViewController(dashboardViewController, animated: false)
    _ = dashboardViewController.view
    fetchAllDashboardData()
  }
  
  func coordinateReview(presenter: UIViewController, type: WebSessionType) {
    reviewCoordinator = ReviewCoordinator(presenter: self.presenter, settingsSuit: settingsSuit, type: type)
    reviewCoordinator?.start()
  }
  
}

// MARK: - DashboardViewControllerDelegate
extension DashboardCoordinator {
  func dashboardPullToRefreshAction() {
    fetchAllDashboardData()
  }
  
  func didSelectCell(indexPath: NSIndexPath) {
    switch (indexPath.section, indexPath.item) {
    case (1, 0):
      if canOpenLessons { coordinateReview(presenter, type: .Lesson) }
    case (1, 1):
      if canOpenReview { coordinateReview(presenter, type: .Review) }
    default:
      break
    }
  }
}

// MARK: - ReviewCoordinatorDelegate
public extension DashboardCoordinator {
  
  func reviewCompleted(coordinator: ReviewCoordinator) {
    reviewCoordinator = nil
  }
  
}
