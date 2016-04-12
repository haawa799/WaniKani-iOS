//
//  SideMenuContainerController.swift
//  WaniKani
//
//  Created by Andriy K. on 1/5/16.
//  Copyright © 2016 Andriy K. All rights reserved.
//

import UIKit

protocol BottomBarContainerDelegate: class {
  func leftButtonPressed()
  func rightButtonPressed()
}

class BottomBarContainerViewController: UIViewController, StoryboardInstantiable {
  
  @IBOutlet weak var barHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var toolBar: UIToolbar!
  
  weak var delegate: BottomBarContainerDelegate?
  
  var childViewController: UIViewController? {
    didSet {
      guard let childViewController = childViewController else { return }
      childViewController.view.frame = containerView.bounds
      addChildViewController(childViewController)
      containerView.addSubview(childViewController.view)
    }
  }
  
}


// MARK: - UIViewController
extension BottomBarContainerViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.showToolbar(false)
  }
  
  override func prefersStatusBarHidden() -> Bool {
    return false//SettingsSuit.sharedInstance.hideStatusBarEnabled
  }
  
}


// MARK: - Actions
extension BottomBarContainerViewController {
  
  @IBAction func leftButtonPressed(sender: UIBarButtonItem) {
    delegate?.leftButtonPressed()
  }
  
  @IBAction func rightButtonPressed(sender: UIBarButtonItem) {
    delegate?.rightButtonPressed()
  }
  
}


// MARK: - Show hide bottom bar
extension BottomBarContainerViewController {
  
  func showBar() {
    toolBar.hidden = false
  }
  
  func hideBar() {
    toolBar.hidden = true
  }
  
}