//
//  DogeHintView.swift
//  
//
//  Created by Andriy K. on 9/10/15.
//
//

import UIKit

//@IBDesignable
class DogeHintView: UIView {
  
  var hideShowAnimationDuration = 0.6
  
  @IBOutlet weak var paddingConstraint: NSLayoutConstraint! {
    didSet {
      paddingConstraint.constant = bounds.height
    }
  }
  
  func show(completion: ((Bool) -> Void)? = nil) {
    
    playBreathingAnimation()
    
    paddingConstraint.constant = 0
    UIView.animateWithDuration(hideShowAnimationDuration, animations: { () -> Void in
      self.layoutIfNeeded()
      }, completion: completion)
  }
  
  func hide(completion: ((Bool) -> Void)? = nil) {
    paddingConstraint.constant = bounds.height
    
    UIView.animateWithDuration(hideShowAnimationDuration, animations: { () -> Void in
      self.layoutIfNeeded()
      }, completion: completion)
  }
  
  private func playBreathingAnimation() {
    
    guard NSProcessInfo.processInfo().environment["isUITest"] == nil else { return }
    
    
    let delay0 = 0.05
    let delay1 = 0.05
    let firstPartDuration = (1 - (delay0 + delay1)) / 2
    let secondPartDuration = firstPartDuration
    
    UIView.animateKeyframesWithDuration(1.8, delay: 0.0, options: UIViewKeyframeAnimationOptions.Repeat, animations: { () -> Void in
      UIView.addKeyframeWithRelativeStartTime(delay0, relativeDuration: firstPartDuration, animations: { () -> Void in
        var transform = CGAffineTransformMakeTranslation(0, -5)
        transform = CGAffineTransformScale(transform, 1.025, 1.025)
        self.dogeImageView.transform = transform//CGAffineTransformMakeScale(1.03, 1.03)
      })
      UIView.addKeyframeWithRelativeStartTime(delay1 + (delay0 + firstPartDuration), relativeDuration: secondPartDuration, animations: { () -> Void in
        self.dogeImageView.transform = CGAffineTransformIdentity
      })
      }) { (success) -> Void in
        
    }
  }
  
  var dogeImageFilename: String = {
    
    let date = NSDate()
    let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)!
    let components = calendar.components([.Month], fromDate: date)
    
    if [12, 1, 2].contains(components.month) {
      return "dogeXMAS"
    }
    
    return "doge"
    
  }()
  
  @IBOutlet weak var dogeImageView: UIImageView! {
    didSet {
      
      dogeImageView.image = UIImage(named: dogeImageFilename)
      NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DogeHintView.didEnterBackground), name: UIApplicationDidEnterBackgroundNotification, object: nil)
      NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DogeHintView.willEnterForeground), name: UIApplicationWillEnterForegroundNotification, object: nil)
    }
  }
  
  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  func willEnterForeground() {
    playBreathingAnimation()
  }
  
  func didEnterBackground() {
    
  }
  
  var message: String? {
    didSet {
      guard let message = message, let textLabel = textLabel else {return}
      textLabel.attributedText = NSAttributedString(string: message)
      applyDefaultAttributes()
    }
  }
  
  @IBOutlet weak var textLabel: UILabel! {
    didSet {
      applyDefaultAttributes()
    }
  }
  
  private func applyDefaultAttributes() {
    guard let atributedString = textLabel.attributedText else {return}
    let mutableString = NSMutableAttributedString(attributedString: atributedString)
    let font = UIFont(name: "Doge Sans", size: 30)!
    mutableString.addAttribute(NSFontAttributeName, value: font, range: NSRange(location: 0, length: atributedString.length - 1))
    textLabel.attributedText = mutableString
  }
  
  var view: UIView!
  
  func xibSetup() {
    view = loadViewFromNib()
    
    // use bounds not frame or it'll be offset
    view.frame = bounds
    
    // Make the view stretch with containing view
    view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
    addSubview(view)
  }
  
  func loadViewFromNib() -> UIView {
    
    let view = NSBundle.mainBundle().loadNibNamed("DogeHintView", owner: self, options: nil).first as! UIView
    
    return view
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    xibSetup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    xibSetup()
  }
}

