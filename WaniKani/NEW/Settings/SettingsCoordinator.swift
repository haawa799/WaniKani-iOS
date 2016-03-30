//
//  SettingsCoordinator.swift
//  WaniKani
//
//  Created by Andriy K. on 3/28/16.
//  Copyright © 2016 Andriy K. All rights reserved.
//

import UIKit

public class SettingsCoordinator: Coordinator, SettingsViewControllerDelegate {
  
  let presenter: UINavigationController
  let settingsViewController: SettingsViewController
  let childrenCoordinators: [Coordinator]
  let suit: SettingsSuit
  
  let dataProvider = DataProvider()
  
  public init(presenter: UINavigationController) {
    self.presenter = presenter
    suit = SettingsSuit(userDefaults: NSUserDefaults.standardUserDefaults(), keychainManager: KeychainManager())
    settingsViewController = SettingsViewController.instantiateViewController()
    let tabItem: UITabBarItem = UITabBarItem(title: "Settings", image: UIImage(named: "settings"), selectedImage: nil)
    presenter.tabBarItem = tabItem
    childrenCoordinators = []
  }
  
  
  func start() {
    let viewModel = suit.collectionViewViewModel
    presenter.pushViewController(settingsViewController, animated: false)
    settingsViewController.delegate = self
    settingsViewController.collectionViewModel = viewModel
  }
  
}

// SettingsViewControllerDelegate
extension SettingsCoordinator {
  
  func cellPressed(indexPath: NSIndexPath) {
    print("indexPath: \(indexPath)")
  }
  
  func cellCheckboxStateChange(id: String, state: Bool) {
    suit.changeSetting(id, state: state)
  }
  
}