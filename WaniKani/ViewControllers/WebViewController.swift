//
//  WebViewController.swift
//
//
//  Created by Andriy K. on 8/26/15.
//
//

import UIKit
import WebKit

//class WebViewController: UIViewController {
//  
//  private var webView: WKWebView? {
//    didSet {
////      webView?.navigationDelegate = self
//    }
//  }
//  var url: String?
//  
//  let configuration = WKWebViewConfiguration()
//  let userContentController = WKUserContentController()
//  
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    
//    if let path = NSBundle.mainBundle().pathForResource("ignore", ofType: "js"), let js = String(contentsOfFile: path, encoding: NSUTF8StringEncoding, error: nil) {
//      let userScript = WKUserScript(source: js, injectionTime: .AtDocumentEnd, forMainFrameOnly: false)
//      
//      
//      userContentController.addUserScript(userScript)
//      userContentController.addScriptMessageHandler(self, name: "interOp")
//      configuration.userContentController = userContentController
//      webView = WKWebView(frame: self.view.bounds, configuration: configuration)
//    }
//    
//    view = webView
//    
//    
//    loadInitialLink()
//  }
//  
//  func loadInitialLink() {
//    if let url = url {
//      if let realURL = NSURL(string: url) {
//        let request = NSURLRequest(URL: realURL)
//        webView?.loadRequest(request)
//      }
//    }
//  }
//}

//extension WebViewController: WKScriptMessageHandler {
//  func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
//    println("\(message.body)")
//  }
//}



class WebViewController: UIViewController {
  
  // Public API:
  var url: String?
  var type = WebSessionType.Lesson
  
  
  private var oldOffset: CGFloat?
  
  @IBOutlet weak var webView: UIWebView! {
    didSet {
      webView.scrollView.delegate = self
      webView.delegate = self
    }
  }
  @IBAction func cancelPressed(sender: AnyObject) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func loadInitialLink() {
    if let url = url {
      if let realURL = NSURL(string: url) {
        let request = NSURLRequest(URL: realURL)
        webView?.loadRequest(request)
        webView?.keyboardDisplayRequiresUserAction = false
      }
    }
  }
  
  private var originalTintColor: UIColor?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    loadInitialLink()
  }
}

extension WebViewController: UIWebViewDelegate {
  func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
    print(request)
    return true
  }
  
  func webViewDidFinishLoad(webView: UIWebView) {
    UserScriptsSuit.sharedInstance.applyUserScriptsToWebView(webView, type: type)
  }
}

extension WebViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(scrollView: UIScrollView) {
    let new = scrollView.contentOffset.y
    let old = oldOffset ?? new
    let delta = max((old - new), -(old - new))
    print(delta)
    if delta > 35 {
      scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: 0)
    }
    oldOffset = new
  }
}