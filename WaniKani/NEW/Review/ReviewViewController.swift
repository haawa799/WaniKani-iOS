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

class ReviewViewController: RESideMenu {
  
  var type: WebSessionType?
  
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
  func sideMenu(sideMenu: RESideMenu!, willShowMenuViewController menuViewController: UIViewController!) {
    guard let word = webViewController?.character() where word.characters.count > 0 else { return }
    
    kanjiPracticeController?.kanjiCharacters = word.characters.map({ (c) -> String in
      return "\(c)"
    })
    
//    if let webViewData = webViewData {
//      appDelegate.fabricManager.postUserSwipedToKanjiPractice(webViewData.type)
//    }
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
