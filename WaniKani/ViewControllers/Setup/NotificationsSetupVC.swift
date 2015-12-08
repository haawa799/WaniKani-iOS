//
//  NotificationsSetupVC.swift
//  WaniKani
//
//  Created by Andriy K. on 11/17/15.
//  Copyright © 2015 Andriy K. All rights reserved.
//

import UIKit
import PermissionScope

class NotificationsSetupVC: SetupStepViewController {
  
  private let pscope: PermissionScope = {
    let p = PermissionScope()
    p.addPermission(NotificationsPermission(notificationCategories: nil), message: "We will only send you notification when Reviews are up. No spam.")
    p.headerLabel.text = "₍ᐢ•ﻌ•ᐢ₎*･ﾟ｡"
    p.bodyLabel.text = "This app works best with notifications."
    p.bodyLabel.superview?.backgroundColor = UIColor(patternImage: UIImage(named: "pattern")!)
    return p
  }()
  
  @IBOutlet weak var dogeHintView: DogeHintView!
  @IBOutlet weak var setupButton: UIButton!
  
  @IBAction func setupNotificationsPressed(sender: AnyObject) {
    pscope.show({ (finished, results) -> Void in
      self.nextButton?.enabled = true
      if results.first?.status == .Authorized {
        self.allowed()
      } else {
        self.denied()
      }
      
      }, cancelled: { (results) -> Void in
        self.nextButton?.enabled = true
        self.canceled()
    })
  }
  
  var userDecided = false
  func allowed() {
    dogeHintView.message  = "Wow, u so smart and much wise! "
    userDecided = true
    setupButton.enabled = false
  }
  
  func canceled() {
    if userDecided == false {
      dogeHintView.message  = "You haven't allowed notifications yet. Go allow them or move on without."
    }
  }
  
  func denied() {
    dogeHintView.message  = "Seems like you don't like notifications. Not a problem, you can allow them later if you want! "
    userDecided = true
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    switch PermissionScope().statusNotifications() {
    case .Unauthorized, .Disabled, .Unknown:
      nextButton?.enabled = false
      setupButton.enabled = true
      dogeHintView.message = "I can keep you so notified when much Reviews or Lessons are avaliable."
      return
    case .Authorized:
      nextButton?.enabled = true
      setupButton.enabled = false
      dogeHintView.message  = "Notifications are all set.\n Proceed to the next step! "
      return
    }
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    delay(0.5) { () -> () in
      self.dogeHintView.show()
    }
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    dogeHintView.hide()
  }
}

extension NotificationsSetupVC {
  
  override func nextStep() {
    dogeHintView.hide { (success) -> Void in
      self.performSegueWithIdentifier("nextPage", sender: self)
    }
  }
  
  override func previousStep() {
    navigationController?.popViewControllerAnimated(true)
  }
  
  override func needsPreviousStep() -> Bool {
    return false
  }
  
  override func needsNextButton() -> Bool {
    return true
  }
}
