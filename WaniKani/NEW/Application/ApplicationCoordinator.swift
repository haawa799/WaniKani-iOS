//
//  ApplicationCoordinator.swift
//  WaniKani
//
//  Created by Andriy K. on 3/14/16.
//  Copyright © 2016 Andriy K. All rights reserved.
//

import UIKit

public class ApplicationCoordinator: Coordinator {
  
  private let dashboardNavigationController = UINavigationController()
  private let dashboardCoordinator: DashboardCoordinator
  
  let window: UIWindow
  let rootViewController = UITabBarController()
  let childrenCoordinators: [Coordinator]
  
  init(window: UIWindow) {
    self.window = window
    dashboardNavigationController.navigationBarHidden = true
    let viewControllers = [dashboardNavigationController]
    rootViewController.setViewControllers(viewControllers, animated: false)
    dashboardCoordinator = DashboardCoordinator(presenter: dashboardNavigationController)
    childrenCoordinators = [dashboardCoordinator]
  }
  
}

// MARK: - Coordinator
extension ApplicationCoordinator {
  func start() {
    window.rootViewController = rootViewController
    dashboardCoordinator.start()
    window.makeKeyAndVisible()
  }
}
