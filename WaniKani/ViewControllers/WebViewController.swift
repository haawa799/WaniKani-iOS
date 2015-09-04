//
//  WebViewController.swift
//  
//
//  Created by Andriy K. on 8/26/15.
//
//

import UIKit
import KINWebBrowser

class WebViewController: UIViewController {
  
  var url: String?
  var oldOffset: CGFloat?
  
  @IBOutlet weak var webView: UIWebView! {
    didSet {
      webView.scrollView.delegate = self
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
      }
    }
  }
  
  private var originalTintColor: UIColor?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    loadInitialLink()
  }
}

extension WebViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(scrollView: UIScrollView) {
    let new = scrollView.contentOffset.y
    var old = oldOffset ?? new
    let delta = max((old - new), -(old - new))
    println(delta)
    if delta > 35 {
      scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: 0)
    }
    oldOffset = new
  }
}