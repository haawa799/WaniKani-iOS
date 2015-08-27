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
  
  var url: String? {
    didSet {
      loadInitialLink()
    }
  }
  
  var kinWebViewController: KINWebBrowserViewController = {
    let webBrowser = KINWebBrowserViewController.webBrowser()
    webBrowser.actionButtonHidden = true
    webBrowser.showsURLInNavigationBar = true
    webBrowser.tintColor = UIColor(red:0.92, green:0.12, blue:0.39, alpha:1)
    return webBrowser
  }()
  
  func loadInitialLink() {
    if let url = url {
      kinWebViewController.loadURLString(url)
    }
  }
  
  private var originalTintColor: UIColor?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addChildViewController(kinWebViewController)
    view.addSubview(kinWebViewController.view)
    kinWebViewController.didMoveToParentViewController(self)
  }
}
