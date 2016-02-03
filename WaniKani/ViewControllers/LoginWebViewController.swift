//
//  LoginWebViewController.swift
//  WaniKani
//
//  Created by Andriy K. on 10/15/15.
//  Copyright © 2015 Andriy K. All rights reserved.
//

import UIKit
import WebKit
import UIImageView_PlayGIF

protocol LoginWebViewControllerDelegate: class {
  func apiKeyReceived(apiKey: String)
}

private enum ScriptHandler: String {
  case ApiKey = "apikey"
  case Password = "password"
  case Username = "username"
}

class LoginWebViewController: UIViewController {
  
  weak var delegate: LoginWebViewControllerDelegate?
  private var webView: WKWebView!
  private var credentials: (user: String, password: String)? = {
    if let usr = appDelegate.keychainManager.user, let psw = appDelegate.keychainManager.password {
      return (usr, psw)
    }
    return nil
  }()
  
  @IBOutlet weak var shibaSpinnerImageView: UIImageView! {
    didSet {
      shibaSpinnerImageView?.gifPath = NSBundle.mainBundle().pathForResource("3dDoge", ofType: "gif")
      shibaSpinnerImageView?.startGIF()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupWebView()
    addBackground(BackgroundOptions.Dashboard.rawValue)
  }
  
  private let script = UserScript(filename: "api_key_script", scriptName: "api_key_script")
  
  private func setupWebView() {
    let source = script.script
    let userScript = WKUserScript(source: source, injectionTime: .AtDocumentEnd, forMainFrameOnly: true)
    
    let userContentController = WKUserContentController()
    userContentController.addUserScript(userScript)
    userContentController.addScriptMessageHandler(self, name: ScriptHandler.ApiKey.rawValue)

    userContentController.addScriptMessageHandler(self, name: ScriptHandler.Username.rawValue)
    userContentController.addScriptMessageHandler(self, name: ScriptHandler.Password.rawValue)
    
    let configuration = WKWebViewConfiguration()
    configuration.userContentController = userContentController
    webView = WKWebView(frame: self.view.bounds, configuration: configuration)
    let request = NSURLRequest(URL: NSURL(string: "https://www.wanikani.com/dashboard")!, cachePolicy: NSURLRequestCachePolicy.ReloadRevalidatingCacheData, timeoutInterval: 15.0)
    webView.loadRequest(request)
    webView.navigationDelegate = self
    view.addSubview(webView)
    
    if credentials != nil {
      webView.userInteractionEnabled = false
      webView.hidden = true
    }
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

extension LoginWebViewController: WKNavigationDelegate {
  
  func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
    if let credentials = credentials {
      webView.evaluateJavaScript("loginIfNeeded('\(credentials.user)','\(credentials.password)');", completionHandler: nil)
    }
  }
}

extension LoginWebViewController: WKScriptMessageHandler {
  
  func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
    
    guard let handler = ScriptHandler(rawValue: message.name) else { return }
    
    switch handler {
    case .ApiKey:
      guard let apiKey = message.body as? String else { return }
      if apiKey == "no" || apiKey == "" {
        if isDeepParsing == false {
          isDeepParsing = true
          webView.evaluateJavaScript("openSettings()", completionHandler: { (response, error) -> Void in
            delay(2.0, closure: { () -> () in
              self.webView.evaluateJavaScript("generateNewKey();", completionHandler: { (response, error) -> Void in
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
      
    case .Username:
      if let string = message.body as? String {
        appDelegate.keychainManager.setUsername(string)
      }
      
    case .Password:
      if let string = message.body as? String {
        appDelegate.keychainManager.setPassword(string)
      }
    }
  }
  
  func submitApiKey(apiKey: String) {
    dismissViewControllerAnimated(true) { () -> Void in
      self.delegate?.apiKeyReceived(apiKey)
    }
  }
  
}
