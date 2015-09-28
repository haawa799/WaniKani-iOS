//
//  BrowserViewController.swift
//  WaniKani
//
//  Created by Andriy K. on 9/28/15.
//  Copyright © 2015 Andriy K. All rights reserved.
//

import UIKit
import WebKit
import NJKScrollFullScreen

class BrowserViewController: UIViewController {
  
  private struct Constants {
    private static let homeLink = "https://www.wanikani.com/dashboard"
    private static let forumLink = "https://www.wanikani.com/community"
  }
  
  var webView: WKWebView!
  var scrollProxy: NJKScrollFullScreen!
  
  @IBOutlet weak var forumsButton: UIBarButtonItem!
  @IBOutlet weak var homeButton: UIBarButtonItem!
  @IBOutlet weak var nextButton: UIBarButtonItem!
  @IBOutlet weak var backButton: UIBarButtonItem!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    webView = WKWebView(frame: view.bounds)
    webView.navigationDelegate = self
    view = webView
    loadURL(Constants.homeLink)
    
    scrollProxy = NJKScrollFullScreen(forwardTarget: self)
    webView.scrollView.delegate = scrollProxy
    scrollProxy.delegate = self
    
    updateButtonsState()
  }
  
  func loadURL(url: String) {
    if let requestURL = NSURL(string: url) {
      UIApplication.sharedApplication().networkActivityIndicatorVisible = true
      let request = NSURLRequest(URL: requestURL, cachePolicy: .ReloadRevalidatingCacheData, timeoutInterval: 15.0)
      webView.loadRequest(request)
    }
  }
}

extension BrowserViewController: NJKScrollFullscreenDelegate {
  
  func scrollFullScreen(fullScreenProxy: NJKScrollFullScreen!, scrollViewDidScrollUp deltaY: CGFloat) {
    moveNavigationBar(deltaY, animated: true)
  }
  
  func scrollFullScreen(fullScreenProxy: NJKScrollFullScreen!, scrollViewDidScrollDown deltaY: CGFloat) {
    moveNavigationBar(deltaY, animated: true)
  }
  
  func scrollFullScreenScrollViewDidEndDraggingScrollUp(fullScreenProxy: NJKScrollFullScreen!) {
    hideNavigationBar(true)
  }
  
  func scrollFullScreenScrollViewDidEndDraggingScrollDown(fullScreenProxy: NJKScrollFullScreen!) {
    showNavigationBar(true)
  }
}

extension BrowserViewController {
  
  @IBAction func nextPressed(sender: UIBarButtonItem) {
    webView.goForward()
  }
  
  @IBAction func previousPressed(sender: UIBarButtonItem) {
    webView.goBack()
  }
  
  @IBAction func homePressed(sender: UIBarButtonItem) {
    loadURL(Constants.homeLink)
  }
  
  @IBAction func forumPressed(sender: UIBarButtonItem) {
    loadURL(Constants.forumLink)
  }
}

extension BrowserViewController: WKNavigationDelegate {
  
  private func updateButtonsState() {
    backButton.enabled = webView.canGoBack
    nextButton.enabled = webView.canGoForward
  }
  
  func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    updateButtonsState()
    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
  }
  
  func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
    updateButtonsState()
    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
  }
}
