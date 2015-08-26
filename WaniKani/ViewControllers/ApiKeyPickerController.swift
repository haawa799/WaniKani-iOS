//
//  ApiKeyPickerController.swift
//  
//
//  Created by Andriy K. on 8/23/15.
//
//

import UIKit
import WaniKit
import KINWebBrowser

class ApiKeyPickerController: UIViewController {
  
  let keyLength = 32
  
  @IBOutlet weak var keyTextField: UITextField! {
    didSet {
      keyTextField.delegate = self
    }
  }
  
  @IBAction func getMyKeyPressed(sender: UIButton) {
    if let url = NSURL(string: "https://www.wanikani.com/account") {
      UIApplication.sharedApplication().openURL(url)
      /*
      UINavigationController *webBrowserNavigationController = [KINWebBrowserViewController navigationControllerWithWebBrowser];
      [self presentViewController:webBrowserNavigationController animated:YES completion:nil];
      
      KINWebBrowserViewController *webBrowser = [webBrowserNavigationController rootWebBrowser];
      [webBrowser loadURLString:@"http://www.example.com"];
      */
//      let webBrowserNavigationController = KINWebBrowserViewController.navigationControllerWithWebBrowser()
//      presentViewController(webBrowserNavigationController, animated: true, completion: nil)
//      let webBrowser = webBrowserNavigationController.rootWebBrowser()
//      webBrowser.loadURLString("http://lebara.im/mela2015")
    }
  }
  
  @IBAction func textDidChange(textField: UITextField) {
    let text = textField.text
    if count(text) == keyLength {
      WaniApiManager.sharedInstance.setApiKey(text)
      dismissViewControllerAnimated(true, completion: nil)
    }
  }
  
}

extension ApiKeyPickerController: UITextFieldDelegate {
}