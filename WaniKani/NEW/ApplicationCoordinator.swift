//
//  ApplicationCoordinator.swift
//  WaniKani
//
//  Created by Andriy K. on 3/14/16.
//  Copyright © 2016 Andriy K. All rights reserved.
//

import UIKit

public class ApplicationCoordinator: Coordinator {
  
  let window: UIWindow
  let rootViewController = UITabBarController()
  let dashboardNavigationController = UINavigationController()
  let dashboardCoordinator: DashboardCoordinator
  
  
  init(window: UIWindow) {
    self.window = window
    dashboardNavigationController.navigationBarHidden = true
    let viewControllers = [dashboardNavigationController]
    self.rootViewController.setViewControllers(viewControllers, animated: false)
    self.dashboardCoordinator = DashboardCoordinator(presenter: dashboardNavigationController)
  }
  
  func start() {
    window.rootViewController = rootViewController
    dashboardCoordinator.start()
    window.makeKeyAndVisible()
  }
}
