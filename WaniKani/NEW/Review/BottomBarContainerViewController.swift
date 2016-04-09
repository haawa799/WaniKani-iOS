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
  
  @IBAction func leftButtonPressed(sender: UIBarButtonItem) {
    delegate?.leftButtonPressed()
  }
  
  @IBAction func rightButtonPressed(sender: UIBarButtonItem) {
    delegate?.rightButtonPressed()
  }
  
  
  @IBOutlet weak var containerView: UIView!
  
  var childViewController: UIViewController? {
    didSet {
      guard let childViewController = childViewController else { return }
      childViewController.view.frame = containerView.bounds
      addChildViewController(childViewController)
      containerView.addSubview(childViewController.view)
    }
  }
  
  weak var delegate: BottomBarContainerDelegate?
  
//  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//    super.prepareForSegue(segue, sender: sender)
//    
//    if let vc = segue.destinationViewController as? SideMenuViewController {
//      self.sideMenuController = vc
//    }
//  }
  
  override func prefersStatusBarHidden() -> Bool {
    return true//SettingsSuit.sharedInstance.hideStatusBarEnabled
  }
  
}

//extension BottomBarContainerViewController {
//  
//  override func viewDidLoad() {
//    super.viewDidLoad()
////    UIDevice.currentDevice().setValue(UIInterfaceOrientation.Portrait.rawValue, forKey: "orientation")
//  }
//  
////  override func shouldAutorotate() -> Bool {
////    // Lock autorotate
////    return false
////  }
//  
//  override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
//    return UIInterfaceOrientationMask.Portrait
//  }
//  
//  override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
//    return UIInterfaceOrientation.Portrait
//  }
//  
//}
