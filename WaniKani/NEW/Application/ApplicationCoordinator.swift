//✅
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
  
  private let settingsNavigationController = UINavigationController()
  private let settingsCoordinator: SettingsCoordinator
  
  let window: UIWindow
  let rootViewController = ColorfullTabBarController()
  let childrenCoordinators: [Coordinator]
  
  init(window: UIWindow) {
    self.window = window
    dashboardNavigationController.navigationBarHidden = true
    settingsNavigationController.navigationBarHidden = true
    let viewControllers = [dashboardNavigationController, settingsNavigationController]
    rootViewController.setViewControllers(viewControllers, animated: false)
    dashboardCoordinator = DashboardCoordinator(presenter: dashboardNavigationController)
    settingsCoordinator = SettingsCoordinator(presenter: settingsNavigationController)
    
    childrenCoordinators = [dashboardCoordinator, settingsCoordinator]
  }
  
}

// MARK: - Coordinator
extension ApplicationCoordinator {
  func start() {
    DataProvider.makeInitialPreperations()
    window.rootViewController = rootViewController
    dashboardCoordinator.start()
    settingsCoordinator.start()
    window.makeKeyAndVisible()
  }
}
