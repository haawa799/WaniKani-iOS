//
//  ApiKeyPickerController.swift
//  
//
//  Created by Andriy K. on 8/23/15.
//
//

import UIKit
import WaniKit

class ApiKeyPickerController: UIViewController {
  
  let keyLength = 32
  
  @IBOutlet weak var keyTextField: UITextField!
  
  @IBAction func getMyKeyPressed(sender: UIButton) {
    performSegueWithIdentifier("getKey", sender: self)
  }
  
  @IBAction func textDidChange(textField: UITextField) {
    let text = textField.text!
    if text.characters.count == keyLength {
      WaniApiManager.sharedInstance().setApiKey(text)
      dismissViewControllerAnimated(true, completion: nil)
      DataFetchManager.sharedInstance.fetchAllData()
    }
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
//    performSegueWithIdentifier("getKey", sender: self)
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
  
  @objc private func tap() {
    keyTextField?.resignFirstResponder()
  }
  
}

extension ApiKeyPickerController: LoginWebViewControllerDelegate {
  func apiKeyReceived(apiKey: String) {
    keyTextField?.text = apiKey
    delay(0.9) { () -> () in
      self.textDidChange(self.keyTextField)
    }
  }
}