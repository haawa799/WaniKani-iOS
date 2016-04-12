//
//  SideMenuViewController.swift
//  WaniKani
//
//  Created by Andriy K. on 12/30/15.
//  Copyright © 2015 Andriy K. All rights reserved.
//

import UIKit
import RESideMenu
import ACEDrawingView
import StrokeDrawingView

protocol ReviewViewControllerDelegate: class {
  func didShowMenu()
  func didColapseMenu()
}

class ReviewViewController: RESideMenu {
  
  var type: WebSessionType?
  weak var reviewDelegate: ReviewViewControllerDelegate?
  
  
  private var webViewController: WebViewController?
  private var kanjiPracticeController: KanjiPracticeViewController?
  
  convenience init(type: WebSessionType, settingsSuit: SettingsSuit?) {
    self.init()
    
    self.webViewController = WebViewController(nibName: "WebViewController", bundle: nil, settingsSuit: settingsSuit)
    self.kanjiPracticeController = KanjiPracticeViewController(nibName: "KanjiPracticeViewController", bundle: nil)
    self.type = type
    self.rightMenuViewController = kanjiPracticeController
    self.contentViewController = webViewController
  }
  
  override func viewDidLoad() {
    
    delegate = self
    webViewController?.delegate = self
    
    super.viewDidLoad()
    
    contentViewInLandscapeOffsetCenterX = 100
    contentViewInPortraitOffsetCenterX = 50
    
    backgroundImage = UIImage(named: "strokes_bg")
    contentViewController.view.backgroundColor = UIColor.clearColor()
    view.clipsToBounds = true
    
    if type == .Review {
      delay(45) { () -> () in
        self.dumpAnimation()
      }
    }
  }
  
  func dumpAnimation() {
    
    let deltaX: CGFloat = -40
    let animationDuration: NSTimeInterval = 0.5
    let holdDuration: NSTimeInterval = 0.3
    let springDamping: CGFloat = 1.0
    
    UIView.animateWithDuration(animationDuration, delay: 0, usingSpringWithDamping: springDamping, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
      self.contentViewController.view.transform = CGAffineTransformMakeTranslation(deltaX, 0)
      }, completion: { (_) -> Void in
        
        delay(holdDuration, closure: { () -> () in
          UIView.animateWithDuration(animationDuration, animations: { () -> Void in
            self.contentViewController.view.transform = CGAffineTransformMakeTranslation(0, 0)
          })
        })
    })
  }
}

extension ReviewViewController: RESideMenuDelegate {
  
  func sideMenu(sideMenu: RESideMenu!, didRecognizePanGesture recognizer: UIPanGestureRecognizer!) {
    
  }
  func sideMenu(sideMenu: RESideMenu!, willShowMenuViewController menuViewController: UIViewController!) {
    
  }
  func sideMenu(sideMenu: RESideMenu!, didShowMenuViewController menuViewController: UIViewController!) {
    
  }
  func sideMenu(sideMenu: RESideMenu!, willHideMenuViewController menuViewController: UIViewController!) {
    
  }
  func sideMenu(sideMenu: RESideMenu!, didHideMenuViewController menuViewController: UIViewController!) {
    reviewDelegate?.didColapseMenu()
  }
  
}

extension ReviewViewController {
  
  override func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
    
    let locationPoint = touch.locationInView(view)
    
    let hitView = view.hitTest(locationPoint, withEvent: nil)
    if (hitView as? ACEDrawingView) != nil || (hitView as? StrokeDrawingView) != nil {
      return false
    }
    
    return true
  }
}

extension ReviewViewController: WebViewControllerDelegate {
  func webViewControllerBecomeReadyForLoad(vc: WebViewController) {
    
    guard let type = type else { return }
    vc.loadReviews(type)
  }
}
