//✅
//  DashboardCoordinator.swift
//  WaniKani
//
//  Created by Andriy K. on 3/14/16.
//  Copyright © 2016 Andriy K. All rights reserved.
//

import UIKit

public class DashboardCoordinator: Coordinator, DashboardViewControllerDelegate {
  
  let presenter: UINavigationController
  let dashboardViewController: DashboardViewController
  var childrenCoordinators: [Coordinator]
  
  let dataProvider = DataProvider()
  
  public init(presenter: UINavigationController) {
    self.presenter = presenter
    dashboardViewController = DashboardViewController.instantiateViewController()
    let tabItem: UITabBarItem = UITabBarItem(title: "Dashboard", image: UIImage(named: "dashboard"), selectedImage: nil)
    presenter.tabBarItem = tabItem
    childrenCoordinators = []
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
    
    
    delay(6) { 
      let coordinator = ReviewCoordinator(presenter: self.presenter)
      coordinator.start()
      self.childrenCoordinators.append(coordinator)
    }
  }
  
}

// MARK: - DashboardViewControllerDelegate
extension DashboardCoordinator {
  func dashboardPullToRefreshAction() {
    fetchAllDashboardData()
  }
}
