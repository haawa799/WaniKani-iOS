//
//  GameCenterSetupVC.swift
//  WaniKani
//
//  Created by Andriy K. on 11/17/15.
//  Copyright © 2015 Andriy K. All rights reserved.
//

import UIKit

class GameCenterSetupVC: SetupStepViewController {
  
  @IBOutlet weak var dogeHintView: DogeHintView! {
    didSet {
      dogeHintView.message = "You can compete with fellow WaniKani users via GameCanter. Or you can disable it here if you want. "
    }
  }
  @IBOutlet weak var flatSwitch: AIFlatSwitch! {
    didSet {
      delay(0.0) { () -> () in
        self.flatSwitch?.setSelected(true, animated: false)
      }
    }
  }
  
  
  override func viewDidLoad
    () {
    super.viewDidLoad()
    
    nextButton?.title = "Done"
    nextButton?.style = UIBarButtonItemStyle.Done
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

extension GameCenterSetupVC {
  
  override func nextStep() {
   
    AwardsManager.sharedInstance.gameCenterSetting.enabled = flatSwitch.selected
    navigationController?.dismissViewControllerAnimated(true, completion: nil)
  }
  
  override func needsPreviousStep() -> Bool {
    return false
  }
  
  override func needsNextButton() -> Bool {
    return true
  }
}