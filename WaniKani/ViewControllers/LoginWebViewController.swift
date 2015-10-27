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
  
  private let script = "$.get('/account').done(function(data, textStatus, jqXHR) { var apiKey = $(data).find('#api-button').parent().find('input').attr('value');window.webkit.messageHandlers.notification.postMessage(apiKey);});"
  
  private func setupWebView() {
    let source = script
    let userScript = WKUserScript(source: source, injectionTime: .AtDocumentEnd, forMainFrameOnly: true)
    
    let userContentController = WKUserContentController()
    userContentController.addUserScript(userScript)
    userContentController.addScriptMessageHandler(self, name: "notification")
    
    let configuration = WKWebViewConfiguration()
    configuration.userContentController = userContentController
    webView = WKWebView(frame: self.view.bounds, configuration: configuration)
    let request = NSURLRequest(URL: NSURL(string: "https://www.wanikani.com/dashboard")!, cachePolicy: NSURLRequestCachePolicy.ReloadRevalidatingCacheData, timeoutInterval: 15.0)
    webView.loadRequest(request)
    view.insertSubview(webView, atIndex: 0)
  }
 
  @IBAction func donePressed(sender: AnyObject) {
    dismissViewControllerAnimated(true, completion: nil)
  }
}

extension LoginWebViewController: WKScriptMessageHandler {
  
  func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
    guard let apiKey = message.body as? String else {return}
    dismissViewControllerAnimated(true) { () -> Void in
      self.delegate?.apiKeyReceived(apiKey)
    }
  }
  
}


