//
//  DogeHintView.swift
//  
//
//  Created by Andriy K. on 9/10/15.
//
//

import UIKit

class DogeHintView: UIView {
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setup()
  }
  
  private func setup() {
    hide()
    delay(1.0, closure: { () -> () in
      self.show()
    })
  }
  
  private func hide() {
    self.transform = CGAffineTransformMakeTranslation(0.0, bounds.height)
  }
  
  private func show() {
    UIView.animateWithDuration(0.6, animations: { () -> Void in
      self.transform = CGAffineTransformMakeTranslation(0.0, 0.0)
    })
  }
  
}
