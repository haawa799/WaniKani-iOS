//
//  SettingsViewController.swift
//  
//
//  Created by Andriy K. on 9/13/15.
//
//

import UIKit
import AIFlatSwitch

class SettingsViewController: UIViewController {
  
  @IBOutlet weak var fastForwardReviewsSwitch: AIFlatSwitch!
  
  @IBAction func fastForwardSwitchValueChanged(sender: AIFlatSwitch) {
    UserScriptsSuit.sharedInstance.fastForwardEnabled = sender.selected
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let state = UserScriptsSuit.sharedInstance.fastForwardEnabled
    fastForwardReviewsSwitch.selected = state
  }
  
}
