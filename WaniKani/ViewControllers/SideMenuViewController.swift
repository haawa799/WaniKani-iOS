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

class SideMenuViewController: RESideMenu {
  
  var url: String?
  var type = WebSessionType.Lesson
  
  private let webViewController = WebViewController(nibName: "WebViewController", bundle: nil)
  private let kanjiPracticeController = KanjiPracticeViewController(nibName: "KanjiPracticeViewController", bundle: nil)
  
  override func viewDidLoad() {
    
    contentViewController = webViewController
    webViewController.delegate = self
    rightMenuViewController = kanjiPracticeController
    CGAffineTransformIdentity
    
    super.viewDidLoad()
    
    backgroundImage = UIImage(named: "strokes_bg")
    contentViewController.view.backgroundColor = UIColor.clearColor()
    view.clipsToBounds = true
    
    //
    kanjiPracticeController.kanjiCharacter = "飲"
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

extension SideMenuViewController {
  
  override func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {

    let locationPoint = touch.locationInView(view)
        
    if let _ = view.hitTest(locationPoint, withEvent: nil) as? ACEDrawingView {
      return false
    }
    
    return true
  }
}

extension SideMenuViewController: WebViewControllerDelegate {
  
  func webViewControllerBecomeReadyForLoad(vc: WebViewController) {
    vc.loadURL(url, type: type)
  }
  
  func startShowingKanji() {
    
  }
  
  func endShowingKanji() {
    
  }
  
}
