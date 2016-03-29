//
//  SettingsCoordinator.swift
//  WaniKani
//
//  Created by Andriy K. on 3/28/16.
//  Copyright © 2016 Andriy K. All rights reserved.
//

import UIKit

public class SettingsCoordinator: Coordinator {
  
  let presenter: UINavigationController
  let settingsViewController: SettingsViewController
  let childrenCoordinators: [Coordinator]
  
  let dataProvider = DataProvider()
  
  public init(presenter: UINavigationController) {
    self.presenter = presenter
    settingsViewController = SettingsViewController.instantiateViewController()
    childrenCoordinators = []
  }
  
  
  func start() {
    
    let suit = SettingsSuit(userDefaults: NSUserDefaults.standardUserDefaults(), keychainManager: KeychainManager())
    let viewModel = suit.collectionViewViewModel
    presenter.pushViewController(settingsViewController, animated: false)
    settingsViewController.collectionViewModel = viewModel
  }
  
}