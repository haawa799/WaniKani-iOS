//
//  ColorfullTabBarController.swift
//  PopcornTime
//
//  Created by Andrew  K. on 4/10/15.
//  Copyright (c) 2015 PopcornTime. All rights reserved.
//

import UIKit


class ColorfullTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    private struct ColorConstants {
        static let dashboardColor = UIColor(red:0.92, green:0.12, blue:0.39, alpha:1)
        static let browserTintColor = UIColor(red:0.27, green:0.39, blue:0.87, alpha:1)
        static let settingsTintColor = UIColor(red:0.5, green:0.81, blue:0.69, alpha:1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        assignColors()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        assignColors()
    }
    
    private func assignColors() {
        switch selectedIndex {
        case 0: view.window?.tintColor = ColorConstants.dashboardColor
        case 1: view.window?.tintColor = ColorConstants.browserTintColor
        case 2: view.window?.tintColor = ColorConstants.settingsTintColor
        default: break
        }
    }
    
    
    // MARK: - UITabBarControllerDelegate
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        self.assignColors()
    }
    
    
}
