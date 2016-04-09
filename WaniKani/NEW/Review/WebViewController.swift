//
//  WebViewController.swift
//
//
//  Created by Andriy K. on 8/26/15.
//
//

import UIKit


protocol WebViewControllerDelegate: class {
  func webViewControllerBecomeReadyForLoad(vc: WebViewController)
}


class WebViewController: UIViewController {
  
  
  private var settingsSuit: SettingsSuit?
  
  // Public API:
  convenience init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?, settingsSuit: SettingsSuit?) {
    self.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    self.settingsSuit = settingsSuit
  }
  
  weak var delegate: WebViewControllerDelegate?
  
  func loadReviews(type: WebSessionType) {
    self.type = type
    if let realURL = NSURL(string: type.url) {
      let request = NSURLRequest(URL: realURL)
      webView?.loadRequest(request)
      webView?.keyboardDisplayRequiresUserAction = false
    }
  }
  
  
  private var type = WebSessionType.Lesson
  
  private var newScoreEarned = 0
  private var oldOffset: CGFloat?
  
  @IBOutlet weak var webView: UIWebView! {
    didSet {
      webView.accessibilityIdentifier = "WebView"
      webView.delegate = self
      delegate?.webViewControllerBecomeReadyForLoad(self)
    }
  }
  
  override func prefersStatusBarHidden() -> Bool {
    return true//SettingsSuit.sharedInstance.hideStatusBarEnabled
  }
  
  func character() -> String? {
    if let response = webView.stringByEvaluatingJavaScriptFromString("getCharacter();") {
      return response
    }
    return nil
  }
}

extension WebViewController: UIWebViewDelegate {
  
  private func checkForNewScore() {
    if let response = webView.stringByEvaluatingJavaScriptFromString("getScore();"),
      let score = Int(response) where score != 0 {
        newScoreEarned += score
    }
  }
  
  private func submitScore() {
    //AwardsManager.sharedInstance.saveHighscore(newScoreEarned)
  }
  
  func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
    
    if type.url.containsString(request.URL!.absoluteString) {
      checkForNewScore()
      return true
    } else {
      return request.URL!.absoluteString == "https://www.wanikani.com/login"
    }
  }
  
  func webViewDidFinishLoad(webView: UIWebView) {
    settingsSuit?.applyUserScriptsToWebView(webView, type: type)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    settingsSuit?.applyResizingScriptsToWebView(webView, type: type)
  }
}