//
//  ApiKeyPickerController.swift
//  
//
//  Created by Andriy K. on 8/23/15.
//
//

import UIKit
import WaniKit

class ApiKeyPickerController: SetupStepViewController {
  
  let keyLength = 32
  var shouldShowShiba = true
  
  // MARK: - IBOutlets and Actions
  @IBOutlet weak var keyTextField: UITextField!
  
  @IBOutlet weak var dogeHintView: DogeHintView! {
    didSet {
      dogeHintView.message = "Hope you'll have much good time here.\nI need you to log into your WaniKani account."
    }
  }
  @IBAction func getMyKeyPressed(sender: UIButton) {
    
    dogeHintView.hide { (success) -> Void in
      self.performSegueWithIdentifier("getKey", sender: self)
    }
  }
  
  @IBAction func textDidChange(textField: UITextField) {
    let text = textField.text!
    if text.characters.count == keyLength {
      WaniApiManager.sharedInstance().setApiKey(text)
      performSegueWithIdentifier("nextPage", sender: self)
      DataFetchManager.sharedInstance.fetchAllData()
    }
  }
  
  @objc private func tap() {
    keyTextField?.resignFirstResponder()
  }
  
}

// MARK: - UIViewController
extension ApiKeyPickerController {
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    delay(0.5) { () -> () in
      if self.shouldShowShiba {
        self.dogeHintView.show()
      }
    }
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let tap = UITapGestureRecognizer(target: self, action: "tap")
    view.addGestureRecognizer(tap)
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    guard let loginVC = segue.destinationViewController as? LoginWebViewController else {return}
    loginVC.delegate = self
  }
}

// MARK: - LoginWebViewControllerDelegate
extension ApiKeyPickerController: LoginWebViewControllerDelegate {
  func apiKeyReceived(apiKey: String) {
    shouldShowShiba = false
    keyTextField?.text = apiKey
    delay(0.9) { () -> () in
      self.textDidChange(self.keyTextField)
    }
  }
}

// MARK: - SetupStepViewController
extension ApiKeyPickerController {
  
  override func nextStep() {
    
  }
  
  override func previousStep() {
    
  }
  
  override func needsPreviousStep() -> Bool {
    return false
  }
  
  override func needsNextButton() -> Bool {
    return false
  }
}