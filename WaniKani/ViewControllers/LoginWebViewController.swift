//
//  LoginWebViewController.swift
//  WaniKani
//
//  Created by Andriy K. on 10/15/15.
//  Copyright © 2015 Andriy K. All rights reserved.
//

import UIKit
import WebKit

protocol LoginWebViewControllerDelegate: class {
  func apiKeyReceived(apiKey: String)
}

class LoginWebViewController: UIViewController {
  
  weak var delegate: LoginWebViewControllerDelegate?
  private var webView: WKWebView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupWebView()
  }
  
  /*
  $.get('/account').done(function(data, textStatus, jqXHR) {
  var apiKey = findKey();
  window.webkit.messageHandlers.notification.postMessage(apiKey)
  });
  
  function findKey()  {
  var apiKey = $('#api-button').parent().find('input').attr('value');
  if (apiKey == null || apiKey.length == 0) {
		apiKey = 'no';
  }
  return apiKey;
  }
  
  window.location.href = '/account';
  
  setTimeout(function() {
  $('#api-button').click();
  }, 1000);
  
  var t = findKey();
  window.webkit.messageHandlers.notification.postMessage(t)
  */
  
  private let script0 = "$.get('/account').done(function(data, textStatus, jqXHR) {var apiKey = findKey();window.webkit.messageHandlers.notification.postMessage(apiKey)});"
  private let script1 = ""
  
  private let script = UserScript(filename: "api_key_script", scriptName: "api_key_script")
  
  
  private func setupWebView() {
    let source = script.script
    let userScript = WKUserScript(source: source, injectionTime: .AtDocumentEnd, forMainFrameOnly: true)
    
    let userContentController = WKUserContentController()
    userContentController.addUserScript(userScript)
    userContentController.addScriptMessageHandler(self, name: "notification")
    
    let configuration = WKWebViewConfiguration()
    configuration.userContentController = userContentController
    webView = WKWebView(frame: self.view.bounds, configuration: configuration)
    let request = NSURLRequest(URL: NSURL(string: "https://www.wanikani.com/dashboard")!, cachePolicy: NSURLRequestCachePolicy.ReloadRevalidatingCacheData, timeoutInterval: 15.0)
    webView.loadRequest(request)
    view.addSubview(webView)
  }
 
  @IBAction func donePressed(sender: AnyObject) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  var isDeepParsing = false {
    didSet {
      if isDeepParsing == true {
        webView.alpha = 0
      }
    }
  }
}

extension LoginWebViewController: WKScriptMessageHandler {
  
  func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
    guard let apiKey = message.body as? String else { return }
    
    if apiKey == "no" || apiKey == "" {
      
      if isDeepParsing == false {
        isDeepParsing = true
        
        webView.evaluateJavaScript("openSettings()", completionHandler: { (response, error) -> Void in
          print(response)
          
          delay(2.0, closure: { () -> () in
            self.webView.evaluateJavaScript("generateNewKey();", completionHandler: { (response, error) -> Void in
              print(response)
              
              delay(2.0, closure: { () -> () in
                self.webView.evaluateJavaScript("findKey();", completionHandler: { (response, error) -> Void in
                  if let apiK = response as? String where apiK.characters.count == 32 {
                    self.submitApiKey(apiK)
                  }
                  self.isDeepParsing = false
                })
              })
            })
          })
          
          
        })
      }

    } else {
      submitApiKey(apiKey)
    }
  }
  
  func submitApiKey(apiKey: String) {
    dismissViewControllerAnimated(true) { () -> Void in
      self.delegate?.apiKeyReceived(apiKey)
    }
  }
  
}


