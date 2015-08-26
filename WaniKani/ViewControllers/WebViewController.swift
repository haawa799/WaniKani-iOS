//
//  WebViewController.swift
//  
//
//  Created by Andriy K. on 8/25/15.
//
//

import UIKit

class WebViewController: UIViewController {
  
  @IBOutlet weak var webView: UIWebView! {
    didSet {
      webView.delegate = self
    }
  }
  
  var url: String?
  
}

extension WebViewController: UIWebViewDelegate {
  
  func webViewDidStartLoad(webView: UIWebView) {

  }
  
  func webViewDidFinishLoad(webView: UIWebView) {

  }
  
  func webView(webView: UIWebView, didFailLoadWithError error: NSError) {

  }
  
  func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
    return true
  }
  
}
