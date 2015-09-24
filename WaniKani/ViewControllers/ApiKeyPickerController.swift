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
    if let url = NSURL(string: "https://www.wanikani.com/account") {
      UIApplication.sharedApplication().openURL(url)
    }
  }
  
  @IBAction func textDidChange(textField: UITextField) {
    let text = textField.text!
    if text.characters.count == keyLength {
      WaniApiManager.sharedInstance().setApiKey(text)
      dismissViewControllerAnimated(true, completion: nil)
      DataFetchManager.sharedInstance.fetchStudyQueue(nil)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let tap = UITapGestureRecognizer(target: self, action: "tap")
    view.addGestureRecognizer(tap)
  }
  
  @objc private func tap() {
    keyTextField?.resignFirstResponder()
  }
  
}